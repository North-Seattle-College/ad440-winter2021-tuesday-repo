import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import { useAxiosClient } from "../hooks/axios-hook";

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
          <div className="homepage-header">Task: {task.title}</div>
          <div className="divider" />
          <ol>
            <div className="homepage-description">
              Description: {task.taskDescription}
            </div>
            <div>
              <button
                onClick={props.onDelete.bind(this, props.taskId)}
                className="btn btn-lg btn-outline-danger ml-4"
              >
                Delete
              </button>
            </div>
          </ol>
        </div>
      )}
    </React.Fragment>
  );
};

export default TaskDetailScreen;
