import json
import pyodbc
import logging
import os
import redis
import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

# GLOBAL VARIABLES
USERS_CACHE = b'users:all'
CACHE_TOGGLE =  os.environ.get('CACHE_TOGGLE')

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info(
        'Python HTTP trigger for /users function is processing a request.')

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

    # Setup redis server
    r = setupRedis()

    try:
        # Return results according to the method
        if method == "GET":
            logging.debug("Attempting to retrieve users...")
            all_users_http_response = get_users(conn, r)
            logging.debug("Users retrieved successfully!")
            return all_users_http_response

        elif method == "POST":
            logging.debug("Attempting to add user...")
            user_req_body = req.get_json()
            new_user_id_http_response = add_user(conn, user_req_body, r)
            logging.debug("User added successfully!")
            return new_user_id_http_response

        else:
            logging.warn(f"Request with method {method} has been recieved, but that is not allowed for this endpoint")
            return func.HttpResponse(status_code=405)

    #displays errors encountered when API methods were called
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    finally: 
        conn.close()
        logging.debug('Connection to DB closed')

def get_users(conn, r):
    try:
        cache = getUsersCache(r)
    except TypeError as err:
        logging.debug(err.args[0])

    if cache:
        logging.debug('Data found and being returned from cache')
        return func.HttpResponse(
            cache.decode('utf-8'),
            status_code=200,
            mimetype='application/json'
        )
    else:
        if(CACHE_TOGGLE == True):
            logging.debug('Cache is empty, seaching database...')

        with conn.cursor() as cursor:
            logging.debug("Using connection cursor to execute query (select all from users)")
            cursor.execute("SELECT userId, email, userPassword, firstName, lastName FROM users")

            # Get users
            logging.debug("Fetching all queried information")
            users_table = list(cursor.fetchall())

            # Clean up to put them in JSON.
            users_data = [tuple(user) for user in users_table]

            # Empty data list
            users = []

            users_columns = [column[0] for column in cursor.description]
            for user in users_data:
                users.append(dict(zip(users_columns, user)))

            logging.debug("User data retrieved and processed, returning information from get_users function")

            # Cache users data
            cacheUsers(r, users)

            return func.HttpResponse(json.dumps(users), status_code=200, mimetype="application/json")

def add_user(conn, user_req_body):
    # Verify that required fields are present..
    logging.debug("Testing the add new user request body for necessary fields...")
    try:
        assert "firstName" in user_req_body, "New user request body did not contain field: 'firstName'"
        assert "lastName" in user_req_body, "New user request body did not contain field: 'lastName'"
        assert "email" in user_req_body, "New user request body did not contain field: 'email'"
        assert "userPassword" in user_req_body, "New user request body did not contain field: 'userPassword'"
    except AssertionError as user_req_body_content_error:
        logging.error("New user request body did not contain the necessary fields!")
        return func.HttpResponse(user_req_body_content_error.args[0], status_code=422)
    
    logging.debug("New user request body contains all the necessary fields!")
    with conn.cursor() as cursor:
        # Unpack user data
        firstName = user_req_body["firstName"]
        lastName = user_req_body["lastName"]
        email = user_req_body["email"]
        userPassword = user_req_body["userPassword"]
        user_params = (firstName, lastName, email, userPassword)

        # Create the query
        add_user_query = """
                         SET NOCOUNT ON;
                         DECLARE @NEWID TABLE(ID INT);
                         INSERT INTO dbo.users (firstName, lastName, email, userPassword)
                         OUTPUT inserted.userId INTO @NEWID(ID)
                         VALUES(?, ?, ?, ?);
                         SELECT ID FROM @NEWID
                         """

        logging.debug("Using connection cursor to execute query (add a new user and get id)")
        
        count = cursor.execute(add_user_query, user_params)

        # Get the user id from cursor
        userId = cursor.fetchval()

        clearUsersCache(r)
        
        logging.debug("User added and new user id retrieved, returning information from add_user function")
        return func.HttpResponse(json.dumps({"userId": userId}), status_code=200, mimetype="application/json")

def setupRedis():
    # Get env variables
    REDIS_HOST = os.environ.get('REDIS_HOST')
    REDIS_KEY = os.environ.get('REDIS_KEY')
    REDIS_PORT = os.environ.get('REDIS_PORT')
    
    return redis.StrictRedis(
        host= REDIS_HOST,
        port= REDIS_PORT,
        db= 0,
        password= REDIS_KEY,
        ssl= True
    )

def cacheUsers(r, users):
    if(CACHE_TOGGLE == True):
        try:
            logging.debug('Caching users...')
            r.set(USERS_CACHE, json.dumps(users), ex=1200)
            logging.debug('Caching complete')
        except Exception as err:
            logging.debug('Caching failed')
            logging.debug(err.args[0])

def getUsersCache(r):
    if(CACHE_TOGGLE == True):
        logging.debug('Checking cache for users...')
        try:
            cache = r.get(USERS_CACHE)
            return cache
        except ExceptionWithStatusCode as err:
            logging.debug('Failed to fetch users from cache')
            return func.HttpResponse(str(err), status_code=err.status_code) 

def clearUsersCache(r):
    r.delete(USERS_CACHE)
    logging.debug('Users Cache deleted successfully')