import React from "react";

import "../css/NavScreen.css";
import NavLinks from "./NavLinks";

const NavScreen = (props) => {
  return (
    <div className="container">
      <div className="header">AD440 Serverless Artillery</div>
      <div className="body">
        <div className="buttons">
          <NavLinks />
        </div>
        <div className="viewPort">{props.children}</div>
      </div>
    </div>
  );
};

export default NavScreen;
