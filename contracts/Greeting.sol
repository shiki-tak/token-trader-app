// テスト用smart contract
pragma solidity ^0.4.15;

contract Greeting {
  string public greeting;

  function Greeting(string _greeting) {
    greeting = _greeting;
  }

  function setGreeting(string _greeting) {
    greeting = _greeting;
  }

  function say() constant returns (string) {
    return greeting;
  }
}
