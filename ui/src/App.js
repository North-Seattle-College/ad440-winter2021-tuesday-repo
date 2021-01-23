import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Switch,
} from "react-router-dom";

import HomePage from "./Components/Pages/HomePage";

import "./Components/css/App.css";

const App = () => {
  return (
    <Router>
      <Switch>
        <Route path="/" exact>
          <HomePage />
        </Route>
        <Redirect to="/" exact />
      </Switch>
    </Router>
  );
};

export default App;
