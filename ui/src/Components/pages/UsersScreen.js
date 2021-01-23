import React, { useState, useEffect } from "react";

import { useAxiosClient } from "../hooks/axios-hook";

const UsersScreen = (props) => {
  const [usersList, setUsersList] = useState([]);
  const { sendRequest } = useAxiosClient();

  // Just need the URL put in place, uncomment this
  useEffect(() => {
    // const fetchUsers = async () => {
    //   try {
    //     const responseData = await sendRequest(
    //       `GET`,
    //       `http://URLHERE/api/users`,
    //       null,
    //       { Authorization: `Bearer token` }
    //     );
    //     setUsersList(responseData.users);
    //   } catch (err) {
    //     console.log(err);
    //   }
    // };
    // fetchUsers();
  }, [sendRequest]);

  return <React.Fragment>{usersList}</React.Fragment>;
};

export default UsersScreen;
