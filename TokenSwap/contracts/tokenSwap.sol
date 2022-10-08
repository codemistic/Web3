//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./sampleToken.sol";

contract TokenSwap {
    SampleToken public token;
    uint256 public rate;

    event TokenBought(
        address indexed account,
        address token,
        uint indexed amount,
        uint rate
    );

    event TokenSold(
        address indexed account,
        address token,
        uint indexed amount,
        uint rate
    );

    constructor(SampleToken _tokenContractAds, uint _rate) {
        token = _tokenContractAds;
        rate = _rate;
    }

    function buyToken() public payable {
        uint tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount);
        token.transfer(msg.sender, tokenAmount);
        emit TokenBought(msg.sender, address(token), tokenAmount, rate);
    }

    function sellToken(uint _amount) public {
        uint ethAmount = _amount / rate;
        require(address(this).balance >= ethAmount);
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(ethAmount);
        emit TokenSold(msg.sender, address(token), _amount, rate);
    }
}
