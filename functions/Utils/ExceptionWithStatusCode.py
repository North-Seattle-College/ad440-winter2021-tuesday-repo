class ExceptionWithStatusCode(Exception):
    def __init__(self, msg, status_code):
        super(ExceptionWithStatusCode, self).__init__(msg)
        self.status_code = status_code