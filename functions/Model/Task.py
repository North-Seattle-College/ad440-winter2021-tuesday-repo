from typing import Dict

# This creates a json model to convert sql queries.

class Task():
    def __init__(
        self,
        taskUserId,
        taskId,
        title,
        taskDescription,
        dateCreated,
        completed,
    ):
        self.taskUserId = taskUserId
        self.taskId = taskId
        self.title = title
        self.taskDescription = taskDescription
        self.dateCreated = dateCreated
        self.completed = completed

    def get(self):
        return "this is a test"


    def getDict(self) -> Dict:
        return {
            "taskId": self.taskId,
            "taskUserId": self.taskUserId,
            "title": self.title,
            "taskDescription": self.taskDescription,
            "dateCreated": self.dateCreated,
            "completed": self.completed
        }
        
