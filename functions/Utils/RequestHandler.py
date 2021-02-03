from ..Model.User import User
from ..Model.Task import Task
import azure.functions as func
from .ExceptionWithStatusCode import ExceptionWithStatusCode

class RequestHandler():

    def getUserId(self, req: func.HttpRequest) -> User:
        req_body = req.form

        # get id (required field)
        try:
            id = req_body['id']
        except KeyError:
            id = None
        
        # get email (required field)
        try:
            email = req_body['email']
        except KeyError:
            raise ExceptionWithStatusCode(
                'Email is required',
                status_code=400
            )
        if len(title) == 0:
            raise ExceptionWithStatusCode(
                'Email cannot be empty',
                status_code=400
            )

        # get userPassword (required field)
        try:
            userPassword = req_body['userPassword']
        except KeyError:
            raise ExceptionWithStatusCode(
                'Email is required',

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
                'Email cannot be empty',
                status_code=400
            )

        # get firstName (required field)
        try:
            firstName = req_body['firstName']
        except KeyError:
            raise ExceptionWithStatusCode(
                'First name is required',
                status_code=400
            )
        if len(title) == 0:
            raise ExceptionWithStatusCode(
                'First Name cannot be empty',
                status_code=400
            )

        # get lastName (required field)
        try:
            lastName = req_body['lastName']
        except KeyError:
            raise ExceptionWithStatusCode(
                'Last Name is required',
                status_code=400
            )
        if len(title) == 0:
            raise ExceptionWithStatusCode(
                'Last Name cannot be empty',
                status_code=400
            )

        # get joinDate (required field)
        # try:
        #     joinDate = req_body['joinDate']
        # except KeyError:
        #     raise ExceptionWithStatusCode(
        #         'Join Date is required',
        #         status_code=400
        #     )
        # if len(title) == 0:
        #     raise ExceptionWithStatusCode(
        #         'Join Date cannot be empty',
        #         status_code=400
        #     )

        return UserId(id, email, password, firstName, lastName, joinDate)
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
