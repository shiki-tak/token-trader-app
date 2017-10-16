pragma solidity ^0.4.15;

import './ERC20Token.sol';

contract TokenIssue {
    event CreateToken(address _token);

    function createToken(address _caller, string _symbol, string _name, uint256 _tokenSupply) {
        address token = new ERC20Token(_caller, _symbol, _name, _tokenSupply);
        CreateToken(token);
    }
}
