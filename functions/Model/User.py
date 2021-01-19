from typing import Dict

# This creates a json model to convert sql queries.

class User():
    def __init__(
        self,
        userId,
        email,
        userPassword,
        firstName,
        lastName,
        joinDate,
    ):
        self.userId = userId
        self.email = email
        self.userPassword = userPassword
        self.firstName = firstName
        self.lastName = lastName
        self.joinDate = joinDate

    def get(self):
        return "this is a test"

    def getDict(self) -> Dict:
        return {
            "userId": self.userId,
            "email": self.email,
            "userPassword": self.userPassword,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "joinDate": self.joinDate
        }