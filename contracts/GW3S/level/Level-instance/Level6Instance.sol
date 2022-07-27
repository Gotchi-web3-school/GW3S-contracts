// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../../AMM/interfaces/IToken.sol";

contract Level6Instance {
    address[] tokens;
    address public player;
    address public factory;
    string[] public TOKENS_NAME = ["level6 GHST", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI"];
    string[] public TOKENS_SYMBOL = ["GHST, ""DAI", "DAI", "DAI", "DAI", "DAI", "DAI"];

    constructor(address player_, address[] memory tokens_) {
        player = player_;
        tokens = tokens_;
        
        IToken(tokens[0]).mint(player_, 10);
        IToken(tokens[6]).mint(player_, 1);
    }
} 