import logging
import json
import os
import pyodbc
import redis
import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode
import datetime
​
# GLOBAL VARIABLES
CACHE_TOGGLE = os.environ.get('CACHE_TOGGLE')
TASKS_CACHE = b'users:userId:tasks:all'
​
# to handle datetime with JSON (NOT WORKING CURRENTLY)
# It serialize datetime by converting it into string
def default(dateHandle):
  if isinstance(dateHandle, (datetime.datetime, datetime.date)):
    return dateHandle.isoformat()
​
# to handle datetime with JSON (NOT WORKING)
# It serialize datetime by converting it into string
def default(o):
  if isinstance(o, (datetime.datetime, datetime.date)):
    return o.isoformat()
​
​
def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger for /users/:userId/task processed a request.')
​
    # Check request method
    method = req.method
    if not method:
        logging.critical('No method available')
        raise Exception('No method passed')
​
    # Get userId from params
    userId = req.route_params.get('userId')
​
    # Create a new connection
    logging.debug("Attempting DB connection!")
    try:
        conn = dbHandler.getConnectionString()
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)
    logging.debug("Connection to DB successful!")
​
    # Setup Redis server
    r = setupRedis()
    logging.debug('Connected to redis server!')
​
    try:
        # Return results according to the method
        if method == "GET":
            logging.debug("trying to get one user with id {} all tasks".format(userId))
            all_tasks_by_userId = getUserTasks(conn, userId, r)
            logging.debug("Users retrieved successfully!")
            return all_tasks_by_userId
​
        elif method == "POST":
            logging.debug("trying to add one task to tasks")
            task_req_body = req.get_json()
            new_task_id = addUserTask(conn, task_req_body, userId, r)
            logging.debug("task added successfully!")
            return new_task_id
​
        else:
            logging.warn(f"Request with method {method} has been recieved, but that is not allowed for this endpoint")
            return func.HttpResponse(status_code=405)
​
    #displays errors encountered when API methods were called
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    finally:
        conn.close()
        logging.debug('Connection to DB closed')
​
def getUserTasks(conn, userId, r):
    try: 
        cache = getTasksCache(r)
    except TypeError as err:
        logging.debug(err.args[0])
​
    if cache:
        logging.debug('Tasks data found in cache and being returned')
        return func.HttpResponse(
            cache.decode('utf-8'),
            status_code=200,
            mimetype='application/json'
        )
    else:
        logging.debug('Data not found in cache searching database...')
        with conn.cursor() as cursor:
            logging.debug('Inside def: getUsersTasks')
            cursor.execute(
                "SELECT taskId, taskUserId, title, taskDescription FROM tasks WHERE taskUserId={}".format(userId)
            )
            logging.debug('Fetching all tasks for user: ' + userId)
            tasks = list(cursor.fetchall())
​
            # Clean up for json format
            task_data = [tuple(task) for task in tasks]
​
            # Empty data list
            tasks = []
            columns = [column[0] for column in cursor.description]
​
            for task in task_data:
                tasks.append(dict(zip(columns, task)))
​
            logging.debug('Tasks retrieved')
​
            # if CACHE_TOGGLE == True: save tasks to cache
            if(CACHE_TOGGLE == True):
                cacheTasks(r, tasks)
​
            return func.HttpResponse(
                json.dumps(tasks),
                status_code=200,
                mimetype='application/json'
            )
​
def addUserTask(conn, task_req_body, userId, r):
    # Verify required fields
    logging.debug('Verifying required fields')
    try:
        assert "title" in task_req_body, "New user request body did not contain field: 'title'"
        assert "description" in task_req_body, "New user request body did not contain field: 'description'"
    except AssertionError as err:
        logging.error("New user request body did not contain the necessary fields!")
        return func.HttpResponse(err.args[0], status_code=400)
​
    logging.debug("New task request body contains all the necessary fields!")
​
    with conn.cursor() as cursor:
        taskUserId = userId
        title = task_req_body['title']
        taskDescription = task_req_body['description']
        #dateCreated = datetime.datetime.now()
        task_params = (taskUserId, title, taskDescription)
        # query DB to create task
        task_query = """
                        SET NOCOUNT ON;
                        DECLARE @NEWID TABLE(ID INT);
                        INSERT INTO dbo.tasks (taskUserId, title, taskDescription)
                        OUTPUT inserted.taskId INTO @NEWID(ID)
                        VALUES(?, ?, ?);
                        SELECT ID FROM @NEWID
                        """
        logging.debug('execute query')
        cursor.execute(task_query, task_params)
        
        # Get the user id from cursor 
        taskId = cursor.fetchval()
        logging.info(taskId)
​
        # Clear cache 
        clearTasksCache(r)
​
        logging.debug('task with id {} added'.format(taskId))
        return func.HttpResponse(
            json.dumps({"taskId": taskId}), 
            status_code=200, 
            mimetype="application/json"
        )
​
def setupRedis():
    # Get env variables
    REDIS_HOST = os.environ.get('REDIS_HOST')
    REDIS_KEY = os.environ.get('REDIS_KEY')
    REDIS_PORT = os.environ.get('REDIS_PORT')
    
    return redis.StrictRedis(
        host= REDIS_HOST,
        port= REDIS_PORT,
        db= 0,
        password= REDIS_KEY,
        ssl= True
    )
​
def cacheTasks(r, tasks):
    if(CACHE_TOGGLE == True):
        try:
            logging.debug('Caching Tasks in redis...')
            r.set(TASKS_CACHE, json.dump(tasks), ex=1200)
            logging.debug('Tasks cached successfully!')
        except Exception as err:
            logging.debug('Caching failed')
            logging.debug(err.args[0])
​
def getTasksCache(r):
    if(CACHE_TOGGLE == True):
        logging.debug('Checking cache for tasks...')
        try:
            cache = r.get(TASKS_CACHE)
            return cache
        except ExceptionWithStatusCode as err:
            logging.debug('Failed to fetch tasks from cache')
            return func.HttpResponse(str(err), status_code=err.status_code)
​
def clearTasksCache(r):
    r.delete(TASKS_CACHE)
    logging.debug('Tasks cache cleared successfully')