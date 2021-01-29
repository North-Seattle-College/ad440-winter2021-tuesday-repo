import logging

import azure.functions as func

from ..Utils.RequestHandler import RequestHandler
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function for get user_id processed a request.')

    try:
        requestHandler = RequestHandler()
        user_id = requestHandler.getUserId(req)
        dbHandler = dbHandler()
        dbHandler.getUserId(user_id)
        return func.HttpResponse("User ID found", status_code=201)
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)
