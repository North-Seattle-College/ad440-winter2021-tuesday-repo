import React, { useState, useEffect } from "react";

import Button from '../uiElements/Button';
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/HomeScreen.css";

const ArtilleryListScreen = (props) => {
  const [scriptList, setScriptList] = useState([])
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    const fetchTestScripts = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nscstrdevusw2tuecommon.blob.core.windows.net/api/artillery?`,
          null,
          null
        );
        setScriptList(responseData);
        console.log(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchTestScripts();
  }, [sendRequest]);


  return (
    <React.Fragment>
      Artillery Tests Taken:
      <div className="divider" />
      <div className="tests-List">
          {scriptList.map((script) => {
            return (
              <Button
                className="task-Button"
                key={script.id}
                to={`/artillery/${script.id}`}
              >
                Test #{script.id}
              </Button>
            );
          })}
        </div>
    </React.Fragment>
  );
};

export default ArtilleryListScreen;
