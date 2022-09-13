// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../../AMM/facets/TokenFacet.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";


contract Level9Instance {
    address[2] public tokens;
    address public factory;
    address public player;
    address public diamond;
    string[] public TOKENS_NAME = ["level9 USDC"];
    string[] public TOKENS_SYMBOL = ["USDC"];

    constructor(address player_, address factory_) {
        player = player_;
        factory = factory_;
        diamond = msg.sender;

        tokens[0] = address(TokenFacet(diamond).deployToken(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        Token(tokens[0]).mint(player_, 25e18);
    }

    function getPair() public returns(address pair) {
        bytes32 tmp;
        address token0 = tokens[0] < tokens[1] ? tokens[0] : tokens[1];
        address token1 = tokens[0] > tokens[1] ? tokens[0] : tokens[1];

        tmp = keccak256(abi.encodePacked(
            hex'ff',
            factory,
            keccak256(abi.encodePacked(token0, token1)),
            IFactory(factory).INIT_CODE_HASH()
        ));

        pair = address(uint160(uint256(tmp)));
    }

    function deployTokenWithFixedSupply(string memory name, string memory ticker, uint256 totalSupply, address to) public returns(address) {
        tokens[1] = TokenFacet(diamond).deployTokenWithFixedSupply(name, ticker, totalSupply, to);
        return (tokens[1]);
    }
}