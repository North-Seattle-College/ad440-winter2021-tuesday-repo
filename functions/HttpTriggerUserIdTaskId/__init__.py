import json
import pyodbc
import logging
import os
import redis
import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

# Setup redis server


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
            getTaskById = getTask(cursor, row)
            logging.debug("Task retrieved successfully!")
            return getTaskById
        elif method == "PUT":
            logging.debug("Attempting to update taskId: " + taskId)
            task_req_body = req.get_json()
            new_task_id_http_response = updateTask(conn, task_req_body)
            logging.debug("Task added successfully!")
            return new_task_id_http_response
        elif method == "DELETE":
            logging.debug('Attempting to delete taskId: ' + taskId)
            return deleteTask(cursor, taskId)
        else:
            logging.warn(f"Request with method {method} has been recieved, but that is not allowed for this endpoint")
            return func.HttpResponse(status_code=405)

    #displays errors encountered when API methods were called
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    finally:
        conn.close()
        logging.debug('Connection to DB closed')

def getTask(cursor, row):
    logging.debug('Retrieving task by Id...')
    columns = [column[0] for column in cursor.description]
    data = dict(zip(columns, row))

    logging.debug('Task retrieved successfully')
    return func.HttpResponse(
        json.dumps(data),
        status_code=200,
        mimetype='application/json'
    )

def updateTask(cursor, task_req_body):
    task_req_body = req.get_json()

    # Validation checks on required fields
    try:
        assert 'title' in task_req_body, 'User did not provide required field: title'
        assert 'taskDescription' in task_req_body, 'User did not provide required field: taskDescription'
    except AssertionError as err:
        logging.error('User request body did not contain the necessary fields!')
        return func.HttpResponse(
            'Task updated',
            status_code=200
        )


def deleteTask(cursor, taskId):
    logging.debug('Attempting to delete taskId: ' + taskId)
    delete_task_query = 'DELETE FROM tasks WHERE taskId={}'.format(taskId)
    logging.debug('Executing delete query')
    cursor.execute(delete_task_query, (taskId))
    logging.debug('task deleted')
    return func.HttpResponse(
        'task deleted',
        status_code=200
    )

def get_task_row(cursor, taskId):
    cursor.execute(
        'SELECT taskId, taskUserId, title, taskDescription FROM tasks WHERE taskId={}'.format(taskId)
    )
    return cursor.fetchone()