import os
import pyodbc
from ..Model.User import User
from ..Model.Task import Task
from typing import List
import logging

SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATABASE')
USERNAME = os.environ.get('USER')
PASSWORD = os.environ.get('PASSWORD')
DRIVER = os.environ.get('DRIVER')

class dbHandler():
    def getConnString(self):
        logging.debug('Compiling database connection string')
        self.conn_string = "Driver={};Server={};Database={};Uid={};Pwd={};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;".format(
        DRIVER, SERVER, DATABASE, USERNAME, PASSWORD)
        logging.debug('Connection string created')


    # [Task # 2] Query and return all user_id's from SQL DB
    def getUserIds(self) -> List[User]:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM Users")
                rows = cursor.fetchall()
        user_id = []
        for row in rows:
            user_id.append(self._rowToProduct(row))
        return user_id

    # [Task # 2] Insert new user_id into SQL DB
    def addUserId(self, user_id: User_Id) -> None:
   # [Task # 3] Query and return all tasks
    def getTasks(self) -> List[Task]:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT taskId, taskUserId, title, taskDescription, completed FROM Tasks")
                rows = cursor.fetchall()
        tasks = []
        for row in rows:
            tasks.append(list(row))
        return tasks

    # [Task # 3] Insert new task into sql db
    def addTask(self, task: Task) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO User_Id (id, email, userPassword, firstName, lastName, joinDate)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """,
                    user_id.id, user_id.email, user_id.userPassword, user_id.firstName, user_id.lastName, user_id.joinDate
                )
                if response:
                    print('Successfully added user with UserId' + user_id.id)
                else:
                    print('An error has occurred.')

    # [Task # 2] Delete user_id from SQL DB
    def deleteUserId(self, user_id: User_Id) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    DELETE FROM User_Id (id, email, userPassword, firstName, lastName, joinDate)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """,
                    user_id.id, user_id.email, user_id.userPassword, user_id.firstName, user_id.lastName, user_id.joinDate
                )
                if response:
                    print('User deleted!')
                else:
                    print('An error has occurred.')
                    INSERT INTO Tasks (title, description, status, id)
                    VALUES (?, ?, ?, ?)
                    """,
                    task.title, task.description, task.status, task.id
                )

    # [Task # 4] Query and return a task with a provided taskID
    def getTask(self, taskID) -> Task:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT taskId, taskUserId, title, taskDescription, completed FROM Tasks WHERE taskID=?', taskID)
                row = cursor.fetchone()
        task = list(row)
        return task

    # [Task # 4] Update a task with provided taskID and additional information
    def putTask(self, taskID, title, taskDescription, completed) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute('UPDATE tasks SET title=?, taskDescription=?, completed=? WHERE taskId=?', title, taskDescription, completed, taskID)
                cursor.execute('SELECT taskId, taskUserId, title, taskDescription, completed FROM Tasks WHERE taskID=?', taskID)
                row = cursor.fetchone()
        task = list(row)
        return task

     # [Task # 4] Delete a task with provided taskID
    def deleteTask(self, taskID) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute('DELETE FROM Tasks WHERE taskId=?', taskID)
        return "Task successfully deleted (dbHander.py)"
