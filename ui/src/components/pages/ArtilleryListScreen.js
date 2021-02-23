import React, { useState, useEffect } from "react";
import { NavLink } from 'react-router-dom';
import Button from '../uiElements/Button';

import DUMMY_TESTS from "../data/dummy-tests.json";
// import ArtJson from '../data/report_for_30req.json';

import { useAxiosClient } from "../hooks/axios-hook";

import "../css/HomeScreen.css";

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
        <div className="homepage-body">Select a script to begin.
         <br />
          {scriptList.map((script) => {
            return (
              <NavLink className="button"
                key={script.id}
                to={`/artillery/${script.id}`}
                onClick={clickHandler}
              >
                Artillery Test Details, Test #{script.id}
              </NavLink>
              // <Button
              //   className="task-Button"
              //   key={script.id}
              //   onClick={clickHandler}
              //   to={`/users/${params.userId}/tasks`}
              // >
              //   {script.name}
              // </Button>
            );
           })}
        </div>
      </section>
    </React.Fragment>
  );
};

export default ArtilleryListScreen;
