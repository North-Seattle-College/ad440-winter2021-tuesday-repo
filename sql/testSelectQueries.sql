
-- List tasks and users by user;
SELECT CONCAT(dbo.users.lastName, ',', dbo.users.firstName) AS userName,
	dbo.tasks.title AS Title,
	dbo.tasks.taskDescription AS "Description"
FROM dbo.tasks
JOIN dbo.users ON (dbo.tasks.taskUserId = dbo.users.userId)
ORDER BY userName DESC;

-- List users by their tasks (to see how many tasks each user has);
SELECT *
FROM dbo.tasks
JOIN dbo.users ON (dbo.tasks.taskUserId = dbo.users.userId);
