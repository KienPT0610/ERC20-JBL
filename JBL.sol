// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import {ERC20} from "./ERC20.sol";

contract Johnbelus is ERC20 {
    constructor() ERC20("Johnbelus", "JBL") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }   

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }
}