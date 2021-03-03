import React from "react";

import "../css/HomeScreen.css";

const HomeScreen = (props) => {
  return (
    <React.Fragment>
      <section>
        <div className="homepage-header">No Script Loaded!</div>
        <div className="divider" />
        <div className="homepage-description">Select a script to begin.</div>
      </section>
    </React.Fragment>
  );
};

export default HomeScreen;
