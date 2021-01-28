import { useState, useCallback } from "react";
import axios from "axios";

export const useAxiosClient = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState();

  const sendRequest = useCallback(
    async (method = "GET", url, data = null, headers = {}) => {
      let responseData;
      setIsLoading(true);
      console.log(method, url, data, headers);
      await axios({
        method,
        url,
        data,
        headers,
      })
        .then((res) => {
          setIsLoading(false);
          responseData = res.data;
        })
        .catch((err) => {
          setError(err.message);
          setIsLoading(false);
          throw err;
        });
      return responseData;
    },
    []
  );

  const clearError = () => {
    setError(null);
  };

  return { isLoading, error, sendRequest, clearError };
};
