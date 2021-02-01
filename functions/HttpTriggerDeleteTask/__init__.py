import logging
import json

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to DeleteTask.')
    try:
        logging.info('Attempting to delete task...')
        taskID = req.params.get('taskID')
        dbHandler().deleteTask(taskID)
        logging.info('Sucessfully deleted task.')
        return func.HttpResponse("Sucessfully deleted task.")
    except ExceptionWithStatusCode as err:
        logging.info('ExceptionWithStatusCode error occured while trying to delete task.')
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        logging.info('Exception error occured while trying to delete task.')
        return func.HttpResponse(str(err), status_code=500)