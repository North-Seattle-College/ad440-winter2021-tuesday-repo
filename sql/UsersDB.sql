-- IDENTITY is like MySQL's AUTO_INCREMENT and takes two args, seed and increment;
-- Seed is the initial value of the first associated row added;
-- Increment is the value by which this initial seed and subsequent values will auto-increment;
-- Email is the email address the user signed up with and is analagous to a username;
CREATE TABLE users (
  userId INT PRIMARY KEY IDENTITY(1,1),
  email VARCHAR(60) NOT NULL,
  userPassword VARCHAR(60),
  firstName VARCHAR(60) NOT NULL,
  lastName VARCHAR(60) NOT NULL,
);

-- 'Completed' is a boolean equivalent with 0 equal to "false" and 1 equal to "true";
CREATE TABLE tasks (
  taskId INT PRIMARY KEY IDENTITY(1,1),
  taskUserId INT NOT NULL,
  title VARCHAR(60),
  taskDescription VARCHAR(500),
  dateCreated DATETIME NOT NULL,
  completed TINYINT NOT NULL DEFAULT 0,
  CONSTRAINT tasks_fk_users
    FOREIGN KEY (taskUserId) REFERENCES users (userId)
);
