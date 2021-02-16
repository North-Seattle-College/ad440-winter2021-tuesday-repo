import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import DUMMY_TESTS from "../data/dummy-tests.json";

import "../css/TestDetailScreen.css";

const ArtilleryDetailScreen = (props) => {
  const [test, setTest] = useState();
  const params = useParams();

  // This will be to get data from actual report file generated
  // by Artillery test;
  // const getData=()=>{
  //   fetch('../data/report_for_30req.json'
  //   ,{
  //     headers : {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //      }
  //   }
  //   )
  //     .then(function(response){
  //       console.log(response)
  //       return response.json();
  //     })
  //     .then(function(myJson) {
  //       console.log(myJson);
  //       setTest(myJson);
  //     });
  // }
  // useEffect(() => {
  //   getData()
  // }, []);

  useEffect(() => {
    DUMMY_TESTS.map((item) => {
      return item.id === parseInt(params.testId) && setTest(item);
    });
  }, [params.testId, test]);

  return (
    <React.Fragment>
      {test === undefined ? (
        <div>Nothing loaded</div>
      ) : (
        <div>
          <div className="test-Header">Test: {test.id}</div>
          <div className="divider" />
          <ol>
            <div className="test-data">
              Test Completion Date: {test.date}
              <br />
              Test Result: {test.result.toString()}
            </div>
          </ol>
        </div>
      )}
    </React.Fragment>
  );
};

export default ArtilleryDetailScreen;
