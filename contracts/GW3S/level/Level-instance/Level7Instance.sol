// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/interfaces/IFactory.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level7Instance {
    address[2] public tokens;
    address public player;
    string[] public TOKENS_NAME = ["level7 GHST", "level7 DAI"];
    string[] public TOKENS_SYMBOL = ["GHST", "DAI"];

    constructor(address player_) {
        player = player_;

        for (uint8 i = 0; i < TOKENS_NAME.length; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(player_, 100);
        }
        IFactory(msg.sender).deployFactory(player_);
    }
}