import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TestDetailScreen.css";

const ArtilleryDetailScreen = (props) => {
  const [test, setTest] = useState();
  const params = useParams();
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/artillery/${params.testId}?`,
          null,
          null
        );
        setTest(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchUsers();
  }, [sendRequest, params.testId]);

  return (
    <React.Fragment>
      {test === undefined ? (
        <div>Nothing loaded</div>
      ) : (
        <div>
          <div className="test-Header">Test Info: {params.testId}</div>
          <div className="divider" />
          <ol>
            <div className="test-data">
                Aggregate Min: {test.aggregate.latency.min}
                Aggregate Max: {test.aggregate.latency.max}
              <br />
                Intermediate Min: {test.intermediate.latency.min}
                Intermediate Max: {test.intermediate.latency.max}                
            </div>
          </ol>
        </div>
      )}
    </React.Fragment>
  );
};

export default ArtilleryDetailScreen;
