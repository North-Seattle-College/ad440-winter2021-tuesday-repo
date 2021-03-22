import React from "react";
import {
  Route,
  Switch,
  Redirect,
  HashRouter,
} from "react-router-dom";

import HomeScreen from "./components/pages/HomeScreen";
import NavScreen from "./components/navigation/NavScreen";

import TaskListScreen from "./components/pages/TaskListScreen";
import TaskDetailScreen from "./components/pages/TaskDetailScreen";

import UsersListScreen from "./components/pages/UserListScreen";
import UserDetailScreen from "./components/pages/UserDetailScreen";

import ArtilleryListScreen from "./components/pages/ArtilleryListScreen";
import ArtilleryDetailScreen from "./components/pages/ArtilleryDetailScreen";

import ServerlessListScreen from "./components/pages/ServerlessListScreen";
import ServerlessDetailScreen from "./components/pages/ServerlessDetailScreen";

import CreateUserScreen from "./components/pages/CreateUserScreen";
import CreateTaskScreen from "./components/pages/CreateTaskScreen";

import "./components/css/App.css";

const App = () => {
  return (
    <HashRouter>
      <NavScreen>
        <Switch>
          <Route path="/" exact>
            <HomeScreen />
          </Route>
          <Route path="/createuser" exact>
            <CreateUserScreen />
          </Route>
          <Route path="/users" exact>
            <UsersListScreen />
          </Route>
          <Route path="/users/:userId" exact>
            <UserDetailScreen />
          </Route>
          <Route path="/users/:userId/tasks" exact>
            <TaskListScreen />
          </Route>
          <Route path="/users/:userId/createtask" exact>
            <CreateTaskScreen />
          </Route>
          <Route path="/users/:userId/tasks/:taskId" exact>
            <TaskDetailScreen />
          </Route>
          <Route path="/artillery" exact>
            <ArtilleryListScreen />
          </Route>
          <Route path="/artillery/:testId" exact>
            <ArtilleryDetailScreen />
          </Route>
          <Route path="/serverless" exact>
            <ServerlessListScreen />
          </Route>
          <Route path="/serverless/:testId" exact>
            <ServerlessDetailScreen />
          </Route>

          <Redirect to="/" exact />
        </Switch>
      </NavScreen>
    </HashRouter>
  );
};

export default App;
