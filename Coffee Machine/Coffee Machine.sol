// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;



contract Coffee{
    address public owner;
    mapping(address=>uint) public coffeeBalance;
    constructor(){
        owner=msg.sender;
        coffeeBalance[address(this)]=100;
    }


    function Coffee_Balance() public view returns(uint){
        return coffeeBalance[address(this)];
    }

    function Purchase_Coffee(uint amount) public payable {
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ETH per donut");
        require(coffeeBalance[address(this)]>amount,"Not enough coffee, need to restock"); 
        coffeeBalance[address(this)]=coffeeBalance[address(this)]-amount;
        coffeeBalance[msg.sender]=coffeeBalance[msg.sender]+amount;
        
    }


    function Restock_Coffee(uint amount) public{
        require(msg.sender==owner, "Only owner can restock the coffee machine");
        coffeeBalance[address(this)]=coffeeBalance[address(this)]+amount;
        
    }

}
