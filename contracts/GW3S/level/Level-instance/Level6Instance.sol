// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/facets/FactoryFacet.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

uint constant MAX = 10000000 * 10 ** 18;
address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

contract Level6Instance {
    address[8] tokens;
    address public player;
    string[] public TOKENS_NAME = ["level6 GHST", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 SECRET"];
    string[] public TOKENS_SYMBOL = ["GHST, ""DAI", "DAI", "DAI", "DAI", "DAI", "DAI", "SECRET"];

    constructor(address player_, address router) {
        player = player_;

        for (uint8 i = 1; i < TOKENS_NAME.length; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(address(this), MAX);
            Token(tokens[i]).approve(router, MAX);
        }
        Token(tokens[0]).mint(player_, 10000000000000000);
        Token(tokens[1]).mint(player_, 10000000000000000);

        address factory = FactoryFacet(msg.sender).deployFactory(player);
        IRouter(router).addLiquidity(tokens[0], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[2], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[3], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[4], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[5], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[6], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[0], tokens[7], MAX / 2, MAX / 2, MAX / 2, MAX / 2, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[1], tokens[7], MAX / 2, MAX / 2, MAX / 2, MAX / 2, address(this), block.timestamp, factory);
    }
} 