// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import {IERC20} from "./IERC20.sol";
import {IERC20Metadata} from "./IERC20Metadata.sol";
import {Ownable} from "./Ownable.sol";

abstract contract ERC20 is IERC20, IERC20Metadata, Ownable {
    mapping (address account => uint256) _balances; 
    
    mapping (address account => mapping (address spender => uint256)) private _allowaces;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns(uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns(uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual returns (bool){
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        if(from == address(0)) {
            // Dùng để mint thêm token
            _totalSupply += amount;
        } else {
            uint256 Frombalance = _balances[from]; // só dư còn lại của from
            require(Frombalance >= amount, "Banlance < amount");
            unchecked {
                _balances[from] = Frombalance - amount;
            }
        }
        if(to == address(0)) {
            // dùng để đốt token
            _totalSupply -= amount;
        } else {
            unchecked {
                _balances[to] += amount;
            }
        }

        emit Transfer(from, to, amount);
    }

    // tăng thêm token
    function _mint(address account, uint256 amount) internal onlyOwner {
        require(account != address(0), "Account no exist!"); // check xem tài khoản cần mint có tồn tại ko
        _transfer(address(0), account, amount);
    }

    // đốt token
    function _burn(address account, uint256 amount) internal onlyOwner {
        require(account != address(0), "Account no exist!"); 
        _transfer(account, address(0), amount);
    }


    function allowance(address owner, address spender) public view returns(uint256 c) {
        return _allowaces[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns(bool) {
        _approve(msg.sender, spender, amount, true);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount, bool emitEvent) internal virtual {
        require(owner != address(0));
        require(spender != address(0));
        require(_balances[owner] >= amount);
        _allowaces[owner][spender] = amount;
    
        if(emitEvent) emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount);
            unchecked {
                _approve(owner, spender, currentAllowance - amount, false);
            }
        }
    }
}