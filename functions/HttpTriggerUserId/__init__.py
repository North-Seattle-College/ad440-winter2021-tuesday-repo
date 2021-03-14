import logging
import pyodbc
import os
import azure.functions as func
import json
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

# This is the Http Trigger for Users/userId
# It connects to the db and retrives the users added to the db by userId


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info(
        'Python HTTP trigger for users/userId is processing a request ')

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
        with conn.cursor() as cursor:
            logging.debug('Checking for user in database: ' + userId)
            row = get_user_row(cursor, userId)
            if not row:
                logging.debug('User not found')
                return func.HttpResponse(
                    'User not found',
                    status_code=404
                )

            # Return results according to the method
            if method == "GET":
                logging.debug("Attempting to retrieve users...")
                getUser = getUserById(cursor, row)
                logging.debug("Users retrieved successfully!")
                return getUser

            elif method == "POST":
                logging.debug("Attempting to create user...")
                logging.debug("This method is not allowed!")

            elif method == "PUT":
                logging.debug("Attempting to update user...")
                return updateUser(req, cursor, userId)
                logging.debug("User added successfully!")

            elif method == "DELETE":
                logging.debug("Attempting to delete user...")
                return deleteUser(cursor, userId)
                logging.debug("User deleted successfully!")

            else:
                logging.warn(
                    f"Request with method {method} has been recieved, but that is not allowed for this endpoint")
                return func.HttpResponse(status_code=405)

    # displays errors encountered when API methods were called
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    finally:
        conn.close()
        logging.debug('Connection to DB closed')

# Get target user by ID


def getUserById(cursor, row):
    logging.debug("Attempting to retrieve user by ID...")
    columns = [column[0] for column in cursor.description]
    data = dict(zip(columns, row))

    logging.debug("Users retrieved successfully!")
    return func.HttpResponse(
        json.dumps(data),
        status_code=200,
        mimetype="application/json"
    )


# For POST and PATCH
def methodNotAllowed():
    logging.debug("This method is not Implemented")
    return func.HttpResponse(
        "Method not allowed!",
        status_code=405
    )


def updateUser(req, cursor, userId):
    user_req_body = req.get_json()

    # Validate request body
    logging.debug("Verifying fields in request body to update a user by ID")
    try:
        assert "firstName" in user_req_body, "User request body did not contain field: 'firstName'"
        assert "lastName" in user_req_body, "User request body did not contain field: 'lastName'"
        assert "email" in user_req_body, "User request body did not contain field: 'email'"
    except AssertionError as err:
        logging.error(
            "User request body did not contain the necessary fields!")
        return func.HttpResponse(
            err.args[0], 
            status_code=400
        )

    logging.debug("User request body contains all the necessary fields!")

    # Unpack user data
    firstName = user_req_body["firstName"]
    lastName = user_req_body["lastName"]
    email = user_req_body["email"]

    # Update user in DB
    update_user_query = "UPDATE users SET firstName = ?, lastName = ?, email = ? WHERE userId= ?"
    logging.debug("Executing query: " + update_user_query)
    cursor.execute(update_user_query, (firstName, lastName, email, userId))
    logging.debug("User was updated successfully!.")
    return func.HttpResponse(
        "User updated",
        status_code=200
    )


def deleteUser(cursor, userId):
    logging.debug("Attempting to retrieve user by ID and delete the user...")
    delete_user_query = "DELETE FROM users  WHERE userId={}".format(userId)
    logging.debug("Executing query: " + delete_user_query)
    cursor.execute(delete_user_query, (userId))
    logging.debug("User was deleted successfully!.")
    return func.HttpResponse(
        "User deleted",
        status_code=200
    )

def get_user_row(cursor, userId):
    cursor.execute('SELECT userId, email, userPassword, firstName, lastName FROM users WHERE userId={}'.format(userId))
    return cursor.fetchone()
