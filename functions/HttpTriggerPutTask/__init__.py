import logging
import json

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to PutTask (update)')

    logging.info('Attempting to retrieve task information...')
    taskID = req.params.get('taskID')
    title = req.params.get('title')
    taskDescription = req.params.get('taskDescription')
    completed = req.params.get('completed')
    logging.info('Succesfully retrieved task information.')

    try:
        logging.info('Attempting to update task...')
        task = dbHandler().putTask(taskID, title, taskDescription, completed)
        logging.info('Sucessfully updated task.')
        return func.HttpResponse(json.dumps(task))
    except ExceptionWithStatusCode as err:
        logging.info('ExceptionWithStatusCode error occured while trying to update task.')
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        logging.info('Exception error occured while trying to update task.')
        return func.HttpResponse(str(err), status_code=500)
