import logging
import json

import azure.functions as func

from ..Utils.RequestHandler import RequestHandler
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function for create user_id processed a request.')

    try:
        logging.debug('Attempting a db connection...')
        requestHandler = RequestHandler()
        logging.debug('Opened connection.')
        user_id = requestHandler.getUserId(req)
        dbHandler = dbHandler()
        logging.debug(f'Attempting to execute POST user query for user {userId}')
        dbHandler.addUserId(user_id)
        logging.debug(f'Executed POST query for {userId}')
        return func.HttpResponse("User ID added", status_code=201)
    except ExceptionWithStatusCode as err:
        logging.error('Unable to create record with requested parameters...')
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        logging.error('Unable to fulfill request; try again...')
        return func.HttpResponse(str(err), status_code=500)
