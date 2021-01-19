import logging
import json

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request. HTTPTriggerPutTask')

    taskID = req.params.get('taskID')
    title = req.params.get('title')
    taskDescription = req.params.get('taskDescription')
    completed = req.params.get('completed')

    try:
        task = dbHandler().putTask(taskID, title, taskDescription, completed)
        return func.HttpResponse(json.dumps(task))
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)
