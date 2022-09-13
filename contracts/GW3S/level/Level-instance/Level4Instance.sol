// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../../AMM/interfaces/IToken.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/facets/FactoryFacet.sol";

uint constant MAX = 10000000e18;

contract Level4Instance {
    address public player;
    address[4] public tokens;

    constructor(address player_, address factory) {
        string[4] memory TOKENS_NAME = ["level4 GHST", "level4 ETH", "level4 AAVE", "level4 DAI"];
        string[4] memory TOKENS_SYMBOL = ["GHST", "ETH", "AAVE", "DAI"];
        player = player_;

        for (uint8 i = 0; i < 4; i++) {
            tokens[i] = IToken(msg.sender).deployToken(TOKENS_NAME[i], TOKENS_SYMBOL[i]);
            IToken(tokens[i]).mint(address(this), 20000000e18);
            IToken(tokens[i]).approve(msg.sender, 20000000e18);
        }

        IToken(tokens[3]).mint(player_, 10e18);

        IRouter(msg.sender).addLiquidity(tokens[0], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(msg.sender).addLiquidity(tokens[2], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(msg.sender).addLiquidity(tokens[3], tokens[2], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
    }

    function getPair(address token0, address token1, address factory) public returns(address pair) {
        bytes32 tmp;
        address tokenA = token0 < token1 ? token0 : token1;
        address tokenB = token0 > token1 ? token0 : token1;

        tmp = keccak256(abi.encodePacked(
            hex'ff',
            factory,
            keccak256(abi.encodePacked(tokenA, tokenB)),
            IFactory(factory).INIT_CODE_HASH()
        ));

        pair = address(uint160(uint256(tmp)));
    }
} 