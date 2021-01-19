from ..Model.Task import Task
import azure.functions as func
from .ExceptionWithStatusCode import ExceptionWithStatusCode


class RequestHandler():

    def getTask(self, req: func.HttpRequest) -> Task:
        req_body = req.form

        # get taskId (required field)
        try:
            taskId = req_body['taskId']
        except KeyError:
            taskId = None

        # get taskUserId (required field)
        try:
            taskUserId = req_body['taskUserId']
        except KeyError:
            taskUserId = None

        # get title (required field)
        try:
            title = req_body['title']
        except KeyError:
            raise ExceptionWithStatusCode(
                'Title is required',
                status_code=400
            )
        if len(title) == 0:
            raise ExceptionWithStatusCode(
                'Title cannot be empty',
                status_code=400
            )

        # get description
        try:
            taskDescription = req_body['taskDescription']
        except KeyError:
            taskDescription = ''

        # get dateCreated
        try:
            dateCreated = req_body['dateCreated']
        except KeyError:
            raise ExceptionWithStatusCode(
                'Date required',
                status_code=400
            )

        # get completed
        try:
            completed = req_body['completed']
        except KeyError:
            raise ExceptionWithStatusCode(
                'required field',
                status_code=400
            )

        return Task(taskId, taskUserId, title, taskDescription, dateCreated, completed)