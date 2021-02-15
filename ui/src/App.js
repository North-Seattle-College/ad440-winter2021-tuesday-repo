import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Switch,
} from "react-router-dom";

import HomeScreen from "./components/pages/HomeScreen";
import UserScreen from "./components/pages/UserScreen";
import NavScreen from "./components/navigation/NavScreen";
import UsersListScreen from "./components/pages/UserListScreen";
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
            <UsersListScreen />
          </Route>
          <Route path="/users/:userId" exact>
            <UserScreen />
          </Route>
          <Redirect to="/" exact />
        </Switch>
      </NavScreen>
    </Router>
  );
};

export default App;
