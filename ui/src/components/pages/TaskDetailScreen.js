import React, { useState, useEffect } from "react";
import { useParams, useHistory } from "react-router-dom";

import { useAxiosClient } from "../hooks/axios-hook";

const TaskDetailScreen = (props) => {
  const [task, setTask] = useState([]);
  const { sendRequest } = useAxiosClient();
  const params = useParams();
  const history = useHistory();

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

  const onDeleteHandler = async () => {
    try {
      const responseData = await sendRequest(
        `DELETE`,
        `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/${params.userId}/tasks/${params.taskId}?`,
        null,
        null
      );
      if (responseData.ok) {
        // I'm not 100% sure we can use responseData.ok here, but it should return true if status is 200-299 range
        history.push(`/users/${params.userId}/tasks`);
      }
    } catch (err) {
      console.log(err);
    }
  };

  // Render the component;
  return (
    <React.Fragment>
      {task === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="homepage-header">Task: {task.title}</div>
          <div className="divider" />
          <ol>
            <div className="homepage-description">
              Description: {task.taskDescription}
            </div>
            <div>
              <button
                onClick={onDeleteHandler}
                className="btn btn-lg btn-outline-danger ml-4">
                Delete Task
              </button>
            </div>
          </ol>
        </div>
      )}
    </React.Fragment>
  );
};

export default TaskDetailScreen;
