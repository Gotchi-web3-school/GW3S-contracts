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
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level4Instance {
    address public player;
    address[7] tokens;
    string[] public TOKENS_NAME = ["level4 GHST", "level4 ETH", "level4 AAVE", "level4 DAI"];
    string[] public TOKENS_SYMBOL = ["GHST", "ETH", "AAVE", "DAI"];

    constructor(address player_, address router) {
        player = player_;
        for (uint8 i = 0; i < 4; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(address(this), 10000000);
            Token(tokens[i]).approve(router, 10000000);
        }
        Token(tokens[0]).mint(player_, 10);

        address factory = FactoryFacet(msg.sender).deployFactory(player);
        IRouter(router).addLiquidity(tokens[0], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[2], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
        IRouter(router).addLiquidity(tokens[4], tokens[2], MAX, MAX, MAX, MAX, address(this), block.timestamp, factory);
    }
} 