import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TaskDetailScreen.css";

// Displays close "details" view of a user's individual Task from their list;
const TaskDetailScreen = (props) => {
  const [task, setTask] = useState([]);
  const { sendRequest } = useAxiosClient();
  const params = useParams();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/${params.userId}/tasks/${params.taskId}?`,
          null,
          null
        );
        setTask(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchUsers();
  }, [sendRequest, params.userId, params.taskId]);

  // Render the component;
  return (
    <React.Fragment>
      {task === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="task-Header">Task: {task.title}</div>
          <div className="divider" />
          <ol>
            <div className="task-description">
              Description: {task.taskDescription}
            </div>
          </ol>
        </div>
      )}
    </React.Fragment>
  );
};

export default TaskDetailScreen;
