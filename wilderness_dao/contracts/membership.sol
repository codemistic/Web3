// PSDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;
contract Membership {
  uint8 public maxMemberAddresses;

  mapping(address => bool) public MemberAddresses;

  uint8 public numAddressesMember;

  constructor(uint8 _maxMemberAddresses) {
  maxMemberAddresses =  _maxMemberAddresses;
}

function addAddressToWhitelist() public {
  require(!MemberAddresses[msg.sender], "Sender has already been Accepted");
  require(numAddressesMember < maxMemberAddresses, "More addresses cant be added, limit reached");
  MemberAddresses[msg.sender] = true;
  numAddressesMember += 1;
}

}