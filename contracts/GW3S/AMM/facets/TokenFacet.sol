// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract TokenFacet {

    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    function deployToken(string memory name, string memory ticker, uint256 totalSupply, address player) public returns(address) {
        Token token = new Token(name, ticker);
        token.mint(player, totalSupply);
        emit Deployed(name, ticker, totalSupply);

        return address(token);
    }
}