// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../../AMM/interfaces/IToken.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IFactory.sol";


contract Level12Instance {
    address public player;
    address[2] public tokens;
    string[] public TOKENS_NAME = ["level12 USDC", "level12 GHST"];
    string[] public TOKENS_SYMBOL = ["USDC", "GHST"];
    address[2] public factories;

    constructor(address player_, address factory1, address factory2) {
        player = player_;
        factories[0] = factory1;
        factories[1] = factory2;

        tokens[0] = address(IToken(msg.sender).deployToken(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        IToken(tokens[0]).mint(player_, 100e18);
        IToken(tokens[0]).mint(address(this), 1000000e18);
        IToken(tokens[0]).approve(msg.sender, 1000000e18);

        tokens[1] = address(IToken(msg.sender).deployToken(TOKENS_NAME[1], TOKENS_SYMBOL[1]));
        IToken(tokens[1]).mint(address(this), 1000000e18);
        IToken(tokens[1]).approve(msg.sender, 1000000e18);

        IRouter(msg.sender).addLiquidity(tokens[0], tokens[1], 10000e18, 25000e18, 10000e18, 25000e18, address(this), block.timestamp, factories[0]);
        IRouter(msg.sender).addLiquidity(tokens[0], tokens[1], 10000e18, 10000e18, 10000e18, 10000e18, address(this), block.timestamp, factories[1]);
    }

    function getPairs() public returns(address pair1, address pair2) {
        bytes32 pairA;
        bytes32 pairB;
        address token0 = tokens[0] < tokens[1] ? tokens[0] : tokens[1];
        address token1 = tokens[0] > tokens[1] ? tokens[0] : tokens[1];

        pairA = keccak256(abi.encodePacked(
            hex'ff',
            factories[0],
            keccak256(abi.encodePacked(token0, token1)),
            IFactory(factories[0]).INIT_CODE_HASH()
        ));
        
        pairB = keccak256(abi.encodePacked(
            hex'ff',
            factories[1],
            keccak256(abi.encodePacked(token0, token1)),
            IFactory(factories[1]).INIT_CODE_HASH()
        ));

        pair1 = address(uint160(uint256(pairA)));
        pair2 = address(uint160(uint256(pairB)));
    }
} 