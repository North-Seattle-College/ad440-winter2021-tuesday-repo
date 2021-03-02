import React from "react";
import { NavLink } from "react-router-dom";

import "../css/NavLinks.css";
import "../css/Button.css";

const NavLinks = (props) => {
  return (
    <div className="buttonContainer">
      <NavLink className="button" to="/">
        Home
      </NavLink>
      <NavLink className="button" to="/users">
        Users
      </NavLink>
      <NavLink className="button" to="/artillery">
        Artillery Tests
      </NavLink>
      <NavLink className="button" to="/serverless">
        Serverless Tests
      </NavLink>
      <NavLink className="button" to="/createuser">
        Create a user
      </NavLink>
    </div>
  );
};

export default NavLinks;
