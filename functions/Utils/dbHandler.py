import os
import pyodbc
from ..Model.Task import Task
from typing import List

SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATABASE')
USERNAME = os.environ.get('USER')
PASSWORD = os.environ.get('PASSWORD')
DRIVER = os.environ.get('DRIVER')


class dbHandler():
    def __init__(self):
        self.conn_string = "Driver={" + DRIVER + "};Server=tcp:nsc-sqlsrv-usw2-sqltest.database.windows.net,1433;Database=" + DATABASE + ";Uid=" + USERNAME + ";Pwd=" + PASSWORD + ";Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
        '''
        'Driver=' + DRIVER + \
            ';Server=' + SERVER + \
            ';PORT=1433;Database=' + DATABASE + \
            ';Uid='+USERNAME+';Pwd='+PASSWORD
            '''

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
                    INSERT INTO Tasks (title, description, status, id)
                    VALUES (?, ?, ?, ?)
                    """,
                    task.title, task.description, task.status, task.id
                )

    # [Task # 4] Query and return a task with a provided taskID
    def getTask(self) -> Task:
        taskID = 1
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT taskId, taskUserId, title, taskDescription, completed FROM Tasks WHERE taskID=?', taskID)
                row = cursor.fetchone()
        task = list(row)
        return task

    # [Task # 4] Update a task with provided taskID and additional information
    def putTask(self, task: Task) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT taskId, taskUserId, title, taskDescription, completed FROM Tasks")
                rows = cursor.fetchall()
        tasks = []
        for row in rows:
            tasks.append(list(row))
        return tasks

     # [Task # 4] Delete a task with provided taskID
    def deleteTask(self, task: Task) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("DELETE FROM tasks WHERE taskId='{task.taskid}'")
        return "Task successfully deleted"