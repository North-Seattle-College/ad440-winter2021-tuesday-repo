import logging

import logging.config

import azure.functions as func

from Utils import RequestHandler
from .Utils.dbHandler import dbHandler
from .Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

#Logging Configuration Dict
LOGGING_CONFIG = {
    'disable_existing_loggers': True,
    'formatters':{
        'consoleFormat': {
            'format': %(levelname)s --> %(message)s ----> %(asctime)s,
            'datefmt' : '%Y-%m-%d %H:%M:%S'
        },
        'fileFormat': {
            'format': %(asctime)s (%(module)s --> %(funcName)s[%(lineno)d]) [%(levelname)s]: %(message)s,
            'datefmt' : '%Y-%m-%d %H:%M'
        }
    },
    'handlers': {
        'file': {
            'level': 'CRITICAL',
            'formatter': 'fileFormat',
            'class': 'logging..handlers.RotatingFileHandler',
            'filename': 'httpUsers.log',
            'backupCount': 3,
            'propagate': True
        },
        'console': {
            'level': 'INFO',
            'formatter': 'consoleFormat',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout'
        }
    }
    'loggers': {
        '': { #root logger
            'handlers': ['file','console']
        },
        '__main__': { # if __name__ == '__main__'
            'handlers': ['file', 'console']
        }
    }
}
logging.config.dictConfig(LOGGING_CONFIG)
log = logging.getLogger('httpTriggers')

def main(req: func.HttpRequest) -> func.HttpResponse:
    log = logging.getLogger(__main__)
    log.debug("Logging is configured")
    log.info('Python HTTP trigger function for create user processed a request.')
    
    try:
        log.info("Trying RequestHandler")
        requestHandler = RequestHandler()
        user_id = requestHandler.deleteUserId(req)
        dbHandler = dbHandler()
        dbHandler.deleteUserId(user_id)
        log.debug("Deleted User: " + user_id)
        return func.HttpResponse("User ID deleted", status_code=201)
    except ExceptionWithStatusCode as err:
        rtn = func.HttpResponse(str(err), status_code=err.status_code)
        log.critical("Exception: " + status_code)
        return rtn
    except Exception as err:
        rtn = func.HttpResponse(str(err), status_code=500)
        log.critical("Exception: " + status_code)
        return rtn 
