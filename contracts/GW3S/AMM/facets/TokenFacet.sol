// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol, address owner) ERC20(name, symbol) {
        transferOwnership(owner);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract TokenFixedSupply is ERC20, Ownable {
    constructor (string memory name, string memory symbol, uint256 totalSupply, address to, address owner) ERC20(name, symbol) {
        transferOwnership(owner);
        _mint(to, totalSupply * 10 ** decimals());
    }
}

contract TokenFacet {
    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    function deployToken(string memory name, string memory ticker) public returns(address) {
        Token token = new Token(name, ticker, msg.sender);
        return address(token);
    }

    function deployTokenWithFixedSupply(
        string memory name, 
        string memory ticker, 
        uint256 totalSupply, 
        address to
        ) public returns(address) {
        TokenFixedSupply token = new TokenFixedSupply(name, ticker, totalSupply, to, msg.sender);
        return address(token);
    }
}