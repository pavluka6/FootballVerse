// log
import store from "../store";

const fetchDataRequest = () => {
  return {
    type: "CHECK_DATA_REQUEST",
  };
};

const fetchDataSuccess = (payload) => {
  return {
    type: "CHECK_DATA_SUCCESS",
    payload: payload,
  };
};

const fetchDataFailed = (payload) => {
  return {
    type: "CHECK_DATA_FAILED",
    payload: payload,
  };
};

export const fetchData = (account) => {
  return async (dispatch) => {
    dispatch(fetchDataRequest());
    try {
      let allClubs = await store
        .getState()
        .blockchain.footballVerseClub.methods.getClubs()
        .call();
      let allOwnerClubs = await store
        .getState()
        .blockchain.footballVerseClub.methods.getOwnerClubs(account)
        .call();

      dispatch(
        fetchDataSuccess({
          allClubs,
          allOwnerClubs,
        })
      );
    } catch (err) {
      console.log(err);
      dispatch(fetchDataFailed("Could not load data from contract."));
    }
  };
};