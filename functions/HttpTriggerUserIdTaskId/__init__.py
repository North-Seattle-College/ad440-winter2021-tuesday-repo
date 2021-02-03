import json
import pyodbc
import logging
import os
import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

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


def updateTask(cursor, task_req_body):


def deleteTask(cursor, taskId):