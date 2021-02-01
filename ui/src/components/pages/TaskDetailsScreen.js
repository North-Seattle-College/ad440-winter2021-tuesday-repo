import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import DUMMY_TASKS from "../data/dummy-tasks.json";

import "../css/TasksDetailsScreen.css";

const TaskDetailsScreen = (props) => {
  const [task, setTask] = useState();
  const params = useParams();
  const [completed, setCompleted] = useState(false);

  // This handles changes to the "Done?" checkbox
  // and updates the value of "task.completed"
  const completedHandler = () => {
    setCompleted(!completed);
    task.completed = !task.completed;
  };

  useEffect(() => {
    DUMMY_TASKS.map((item) => {
      return item.taskId === parseInt(params.taskId) && setTask(item);
    });
  }, [params.taskId, params.completed]);

  return (
    <React.Fragment>
      {task === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="task-Header">Task: {task.title}</div>
          <div className="divider" />
          <div className="task-description">
            Description: {task.taskDescription}<br />
            Date created: {task.dateCreated}
          </div>
          Done?
          <input
            type="checkbox"
            name="completed"
            value={task.completed}
            checked={task.completed ? "checked" : ""}
            onChange={completedHandler}
          />
        </div>
      )}
    </React.Fragment>
  );
};

export default TaskDetailsScreen;
