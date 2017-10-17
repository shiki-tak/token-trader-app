// ERC20に準拠したトークンを発行する
// TODO: Interfaceの実装を行うとWrong number of argumentsのエラーになる
pragma solidity ^0.4.15;

// import './ERC20Interface.sol';

contract ERC20Token {

  string public name;
  string public symbol;
  uint8 public constant floats = 18;

  // Owner of this contract
  address public owner;

  uint totalTokens;

  // Balances for each account
  mapping (address => uint) balances;

  // Owner of account approves the transfer of an amount to another account
  mapping (address => mapping (address => uint) ) allowed;

  // Constructor
  function ERC20Token(address _owner, string _name, string _symbol, uint _totalTokens) {
    owner = _owner;
    name = _name;
    symbol = _symbol;
    balances[owner] = _totalTokens;
    totalTokens = _totalTokens;
  }

  function totalSupply() constant returns (uint totalSupply) {
    return totalTokens;
  }

  // Transfer the balance from owner's account to another account
  function transfer(address _to, uint _amount) returns (bool success) {
    return transferInternal(msg.sender, _to, _amount);
  }

  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  // Send _value amount of tokens from address _from to address _to
  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-currencies; the command should fail unless the _from account has
  // deliberately authorized the sender of the message via some mechanism; we propose
  // these standardized APIs for approval:
  function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
    if (balances[_from] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
        balances[_from] -= _amount;
        balances[_to] += _amount;
        Transfer(_from, _to, _amount);
        return true;
      } else {
        return false;
      }
  }

  /*Allow _spender to withdraw from your account, multiple times, up to the value amount.
  If this function is called again it overwrites the current allowance with _value.*/
  function approve(address _spender, uint256 _amount) returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }

  function transferInternal(address _owner, address _to, uint _amount) returns (bool success) {
    if (balances[_owner] >= _amount && _amount > 0) {
      balances[_owner] -= _amount;
      balances[_to] += _amount;
      Transfer(_owner, _to, _amount);
      return true;
    }
    return false;
  }

  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}
