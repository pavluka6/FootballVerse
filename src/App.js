import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { connect } from "./redux/blockchain/blockchainActions";
import logo from './logo.svg';
import './App.css';

function App() {
  const dispatch = useDispatch();
  const blockchain = useSelector((state) => state.blockchain)

  console.table(blockchain);
  useEffect(() => {
    dispatch(connect())
  }, [dispatch])
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
