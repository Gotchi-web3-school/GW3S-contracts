// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level5Instance {
    address owner;
    address public player;
    address public token_;
    string public TOKENS_SYMBOL = "CATCH";
    string public TOKENS_NAME = "Who am I ?";
    uint8 public completed;

    modifier onlyOwner() {
        require(msg.sender == owner, "setCompleted: Only owner can call this function");
        _;
    }

    constructor(address player_) {
        player = player_;
        owner = msg.sender;

        token_ = address(new Token(TOKENS_NAME, TOKENS_SYMBOL));
        Token(token_).mint(player_, 1);
    }

    function setCompleted(uint8 state) public onlyOwner {
        completed = state;
    }
}