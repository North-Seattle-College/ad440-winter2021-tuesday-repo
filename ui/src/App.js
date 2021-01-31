import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Switch,
} from "react-router-dom";

import NavScreen from "./components/navigation/NavScreen";
import HomeScreen from "./components/pages/HomeScreen";
import UsersScreen from "./components/pages/UsersScreen";
import TasksScreen from "./components/pages/TasksScreen";
import TaskDetailsScreen from "./components/pages/TaskDetailsScreen";

import "./components/css/App.css";

const App = () => {
  return (
    <Router>
      <NavScreen>
        <Switch>
          <Route path="/" exact>
            <HomeScreen />
          </Route>
          <Route path="/users" exact>
            <UsersScreen />
          </Route>
          <Route path="/users/:userId/tasks" exact>
            <TasksScreen />
          </Route>
          <Route path="/users/:userId/tasks/:taskId" exact>
            <TaskDetailsScreen />
          </Route>
          <Redirect to="/" exact />
        </Switch>
      </NavScreen>
    </Router>
  );
};

export default App;
