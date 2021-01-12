-- Create a new database called 'UsersDB';
-- Connect to the 'master' database (MS SQL Server configuration DB) to run this snippet;
-- This uses "T-SQL" syntax;
USE master
GO
IF NOT EXISTS (
   SELECT name
   FROM sys.databases
   WHERE name = N'UsersDB'
)
CREATE DATABASE [UsersDB]
GO
