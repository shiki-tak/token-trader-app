pragma solidity ^0.4.15;

import './ERC20Token.sol';

contract SwapTrade {

    function trade(address _makerTokenAddr, address _makerAddr, address _takerTokenAddr, address _takerAddr, uint _amount) returns (bool success) {
        assert(ERC20Token(_makerTokenAddr).transferFrom(_makerAddr, _takerAddr, _amount) && ERC20Token(_takerTokenAddr).transferFrom(_takerAddr, _takerAddr, _amount));
        return true;
    }
}
