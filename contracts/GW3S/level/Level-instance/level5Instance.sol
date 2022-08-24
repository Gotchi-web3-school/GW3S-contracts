// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }

    function secretMint(uint256 amount) public {
        _mint(msg.sender, amount * 10 ** decimals());
    }

    function clean(address player) external onlyOwner {
        _burn(player, balanceOf(player));
    }
}

contract Level5Instance {
    address _owner;
    address public player;
    address public token_;
    string public TOKENS_SYMBOL = "CATCH";
    string public TOKENS_NAME = "Who am I ?";
    uint8 public completed;
    address public guess;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    constructor(address player_) {
        player = player_;
        _owner = msg.sender;

        token_ = address(new Token(TOKENS_NAME, TOKENS_SYMBOL));
        Token(token_).mint(player_, 1);
    }

    function insertAddress(address guess_) public {
        guess = guess_;
    }

    function setCompleted(uint8 state) public onlyOwner {
        completed = state;
    }

    function clean() external onlyOwner {
        Token(token_).clean(player);
    }
}