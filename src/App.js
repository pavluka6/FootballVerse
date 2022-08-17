import React, {useEffect} from "react";
import { useDispatch, useSelector } from "react-redux";
import { connect } from "./redux/blockchain/blockchainActions";
import './App.css';
import { fetchData } from "./redux/data/dataActions";
import * as s from "./styles/globalStyles";


function App() {
  const dispatch = useDispatch();
  const blockchain = useSelector((state) => state.blockchain)
  const data = useSelector((state) => state.data)

  console.log(data)

  const mintNft = (account, name) => {
    blockchain.footballVerseClub.methods._createClub(name).send({
      from: account,
      value: 1000000000000000000,
    }).once("error", (err) => {
      console.log(err);
    }).then((receipt) => {
      console.log(receipt);
      dispatch(fetchData(blockchain.account));
    });
  };

  useEffect(() => {
    if (blockchain.account != "" && blockchain.lipToken != null) {
      dispatch(fetchData(blockchain.account));
    }
  }, [blockchain.lipToken]);

  return (
    <s.Screen>
        {blockchain.account === "" || blockchain.footballVerseClub === null ? (
          <s.Container 
          flex={1}
          ai={"center"}
          jc={"center"}>
        <s.TextTitle>
          Connect to the FootballVerse
        </s.TextTitle>
          <button onClick={(e) => {
            e.preventDefault();
            dispatch(connect());
          }}>CONNECT</button>
        </s.Container>
    ) : (
      <s.Container 
      flex={1}
      ai={"center"}
      jc={"center"}>
        <s.TextTitle>
          Welcome to the FootballVerse
        </s.TextTitle>
        <button onClick={(e) => {
            e.preventDefault();
            console.log(blockchain.account);
            mintNft(blockchain.account, "Dinamo Zagreb");
          }}>MINT YOUR CLUB</button>
          <s.SpacerSmall>
          <s.Container>
            <s.TextDescription>NAME: {data.allClubs[0].name}</s.TextDescription>
            <s.TextDescription>STADIUM: {data.allClubs[0].stadium}</s.TextDescription>
            <s.TextDescription>ACADEMY: {data.allClubs[0].academy}</s.TextDescription>
          </s.Container>
          </s.SpacerSmall>
        </s.Container>
            
    )}
    </s.Screen>
  );
}

export default App;
