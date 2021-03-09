import json
import pyodbc
import logging
import os
import redis
import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

# GLOBAL VARIABLES
CACHE_TOGGLE = os.environ.get('CACHE_TOGGLE')
USERID_TASKS_ALL_CACHE = b'users:{user_id}:tasks:all'
USERID_TASKID_CACHE = b'users:{userId}/tasks/{taskId}'


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info(
        'Python HTTP trigger for /users/:userId/tasks/:taskId function is processing a request.')

    # Check request method
    method = req.method
    if not method:
        logging.critical('No method available')
        raise Exception('No method passed')

    # Create a new connection
    logging.debug("Attempting DB connection!")
    try:
        conn = dbHandler.getConnectionString()
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)
    logging.debug("Connection to DB successful!")

    # Setup redis server
    r = setupRedis()

    try:
        userId = req.route_params.get('userId')
        taskId = req.route_params.get('taskId')
        with conn.cursor() as cursor:
            logging.debug('Checking if task is in DB taskId: ' + taskId)
            row = get_task_row(cursor, taskId)
            if not row:
                logging.debug('Task not found')
                return func.HttpResponse(
                    'Task not found',
                    status_code=404
                )

        # Return results according to the method
        if method == "GET":
            logging.debug("Attempting to retrieve task: " + taskId)
            getTaskById = getTask(conn, taskId, r)
            logging.debug("Task retrieved successfully!")
            return getTaskById
        elif method == "POST":
            logging.debug("Attempting to create task...")
            logging.debug("This method is not allowed!")
        elif method == "PUT":
            logging.debug("Attempting to update taskId: " + taskId)
            task_req_body = req.get_json()
            new_task_id_http_response = updateTask(conn, task_req_body, r)
            logging.debug("Task added successfully!")
            return new_task_id_http_response
        elif method == "DELETE":
            logging.debug('Attempting to delete taskId: ' + taskId)
            return deleteTask(conn, taskId, r)
        else:
            logging.warn(f"Request with method {method} has been recieved, but that is not allowed for this endpoint")
            return func.HttpResponse(status_code=405)

    # displays errors encountered when API methods were called
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    finally:
        conn.close()
        logging.debug('Connection to DB closed')


def getTask(conn, taskId, r):
    try:
        cache = getTaskIdCache(r)
    except TypeError as err:
        logging.debug(err.args[0])

    if cache:
        logging.debug('Data found in cache...')
        return func.HttpResponse(
            cache.decode('utf-8'),
            status_code=200,
            mimetype='application/json'
        )
    else:
        if(CACHE_TOGGLE == True):
            logging.debug('cache is empty searching database...')

        with conn.cursor() as cursor:
            logging.debug(
                'Using connection to execute sql query for taskId...')

            row = get_task_row(cursor, taskId)
            if not row:
                logging.debug('Task not found')
                return func.HttpResponse(
                    'Task not found',
                    status_code=404
                )

            columns = [column[0] for column in cursor.description]
            data = dict(zip(columns, row))

            # Cache taskId data
            cacheTaskId(r, taskId)

            logging.debug('Task retrieved successfully')
            return func.HttpResponse(
                json.dumps(data),
                status_code=200,
                mimetype='application/json'
            )


def methodNotAllowed():
    logging.debug("This method is not implemented")
    return func.HttpResponse(
        "Method not allowed",
        status_code=405
    )


def updateTask(conn, task_req_body, r):
    if not task_req_body:
        logging.debug('no params passed')
        return func.HttpResponse(status_code=500)
    # Validation checks on required fields
    try:
        assert 'title' in task_req_body, 'User did not provide required field: title'
        assert 'taskDescription' in task_req_body, 'User did not provide required field: taskDescription'
    except AssertionError as err:
        logging.error(
            'User request body did not contain the necessary fields!')
        return func.HttpResponse(
            err.args[0],
            status_code=400
        )

    logging.debug('Request body contains all the necessary fields!')
    with conn.cursor() as cursor:
        title = task_req_body['title']
        taskDescription = task_req_body['taskDescription']
        taskParams = (title, taskDescription)

        # update in database
        updateTaskQuery = 'UPDATE [dbo].[tasks] SET title = ?, taskDescription = ? WHERE userId = ? AND taskId = ?'
        executeQuery = cursor.execute(updateTaskQuery, taskParams)
        if not executeQuery:
            logging.error(
                'There was an ERROR updating this task or it does NOT exist.')
            return func.HttpResponse(
                'Bad or invalid input',
                status_code=404
            )

        # Clear taskId cache
        clearTaskIdCache(r)

        logging.debug('Task updated successfully')
        return func.HttpResponse(
            'Success',
            status_code=200
        )

    logging.debug('Request body contains all the necessary fields!')
    with conn.cursor() as cursor:
        title = task_req_body['title']
        taskDescription = task_req_body['taskDescription']
        taskParams = (title, taskDescription)

        # update in database
        updateTaskQuery = 'UPDATE [dbo].[tasks] SET title = ?, taskDescription = ? WHERE userId = ? AND taskId = ?'
        executeQuery = cursor.execute(updateTaskQuery, taskParams)
        if not executeQuery:
            logging.error(
                'There was an ERROR updating this task or it does NOT exist.')
            return func.HttpResponse(
                'Bad or invalid input',
                status_code=404
            )

        # Clear taskId cache
        clearTaskIdCache(r)

        logging.debug('Task updated successfully')
        return func.HttpResponse(
            'Success',
            status_code=200
        )


def deleteTask(conn, taskId, r):
    logging.debug('Attempting to delete taskId: ' + taskId)
    with conn.cursor() as cursor:
        delete_task_query = 'DELETE FROM tasks WHERE taskId={}'.format(taskId)
        logging.debug('Executing delete query')
        cursor.execute(delete_task_query, (taskId))
        logging.debug('task deleted')

        clearTaskIdCache(r)

        return func.HttpResponse(
            'task deleted',
            status_code=200
        )


def get_task_row(cursor, taskId):
    if not taskId:
        logging.debug('No task defined')
    cursor.execute(
        'SELECT taskId, taskUserId, title, taskDescription FROM tasks WHERE taskId={}'.format(
            taskId)
    )
    return cursor.fetchone()


def setupRedis():
    # Get env variables
    REDIS_HOST = os.environ.get('REDIS_HOST')
    REDIS_KEY = os.environ.get('REDIS_KEY')
    REDIS_PORT = os.environ.get('REDIS_PORT')

    return redis.StrictRedis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        db=0,
        password=REDIS_KEY,
        ssl=True
    )
    return cursor.fetchone()


def setupRedis():
    # Get env variables
    REDIS_HOST = os.environ.get('REDIS_HOST')
    REDIS_KEY = os.environ.get('REDIS_KEY')
    REDIS_PORT = os.environ.get('REDIS_PORT')

    return redis.StrictRedis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        db=0,
        password=REDIS_KEY,
        ssl=True
    )


def cacheTaskId(r, taskId):
    if(CACHE_TOGGLE == True):
        try:
            logging.debug('Caching taskId - {taskId} ...')
            r.set(USERID_TASKID_CACHE, json.dumps(taskId), ex=1200)
            logging.debug('Caching complete')
        except Exception as err:
            logging.debug('Caching failed')
            logging.debug(err.args[0])


def getTaskIdCache(r):
    if(CACHE_TOGGLE == True):
        logging.debug('Checking cache for taskId...')
        try:
            cache = r.get(USERID_TASKID_CACHE)
            return cache
        except ExceptionWithStatusCode as err:
            logging.debug('Failed to fetch taskId from cache')
            return func.HttpResponse(str(err), status_code=err.status_code)


def clearTaskIdCache(r):
    r.delete(USERID_TASKID_CACHE)
    logging.debug('TaskId Cache deleted successfully')
