import React, { useState, useEffect } from "react";

// UI imports
import Button from '../uiElements/Button';

// Dummy data imports
import DUMMY_TESTS from "../data/dummy-tests.json";

// Hook imports
import { useAxiosClient } from "../hooks/axios-hook";

// Stylesheets
import "../css/HomeScreen.css";

// Begin: our component;
const ArtilleryListScreen = (props) => {
  const [scriptList, setScriptList] = useState([])
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    setScriptList(DUMMY_TESTS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    // const fetchTestScripts = async () => {
    //   try {
    //     const responseData = await sendRequest(
    //       `GET`,
    //       `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/%7BuserId%7D/tasks`,
    //       null,
    //       { Authorization: `Bearer token` }
    //     );
    //     setScriptList(responseData.users);
    //   } catch (err) {
    //     console.log(err);
    //   }
    // };
    // fetchTestScripts();
  }, [sendRequest]);

  function clickHandler() {
    console.log("I'm a button.");
  }

  return (
    <React.Fragment>
      <section>
        <div className="homepage-body">
          Select a script to begin.
          <br />
          {scriptList.map((script) => {
            return (
              <Button
                className="task-Button"
                key={script.id}
                onClick={clickHandler}
                to={`/artillery/${script.id}`}
              >
                Artillery Test Details, Test #{script.id}
                {script.name}
              </Button>
            );
          })}
        </div>
      </section>
    </React.Fragment>
  );
};

export default ArtilleryListScreen;
