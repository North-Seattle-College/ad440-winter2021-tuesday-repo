import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Switch,
} from "react-router-dom";

import HomeScreen from "./components/pages/HomeScreen";
import UserListScreen from "./components/pages/UserListScreen";
import TaskScreen from "./components/pages/TaskListScreen";
import NavScreen from "./components/navigation/NavScreen";
import TaskListScreen from "./components/pages/TaskListScreen";
import ArtilleryListScreen from "./components/pages/ArtilleryListScreen.js";
import ServerlessListScreen from "./components/pages/ServerlessListScreen";
import ArtilleryDetailScreen from "./components/pages/ArtilleryDetailScreen";
import ServerlessDetailScreen from "./components/pages/ServerlessDetailScreen";

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
            <UserListScreen />
          </Route>
          <Route path="/users/:userId" exact>
            <UserListScreen />
          </Route>
          <Route path="/users/:userId/tasks" exact>
            <TaskListScreen />
          </Route>
          <Route path="/users/:userId/tasks/:taskId" exact>
            <TaskScreen />
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
    </Router>
  );
};

export default App;
