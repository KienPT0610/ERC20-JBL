// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Ownable {
    address private owner;
    constructor (address account) {
        owner = account;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner");
        _;
    }
}