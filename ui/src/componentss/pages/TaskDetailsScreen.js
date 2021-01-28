import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import DUMMY_TASKS from "../data/dummy-tasks.json";

import "../css/TasksDetailsScreen.css";

const TaskDetailsScreen = (props) => {
  const [task, setTask] = useState();
  const params = useParams();

  useEffect(() => {
    DUMMY_TASKS.map((item) => {
      return item.id === parseInt(params.taskId) && setTask(item);
    });
  }, [params.taskId]);

  return (
    <React.Fragment>
      {task === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="task-Header">Name: {task.name}</div>
          <div className="divider" />
          <div className="task-description">
            Description: {task.description}
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default TaskDetailsScreen;
