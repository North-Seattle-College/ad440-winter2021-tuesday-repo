
-- The following queries are to delete the tables so they can be remade (for dev purposes);
-- One must drop the 'tasks' table first, as it has foreign-key dependencies in 'users';
DROP TABLE tasks;
GO
DROP TABLE users;
GO
