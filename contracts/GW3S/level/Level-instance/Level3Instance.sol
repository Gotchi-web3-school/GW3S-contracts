// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/facets/FactoryFacet.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

uint constant MINT = 10000000 * 10 ** 18;
address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level3Instance {
    address public player;
    address[2] tokens;
    string[] public TOKENS_NAME = ["level3 DAI", "level3 GHST"];
    string[] public TOKENS_SYMBOL = ["DAI", "GHST"];

    constructor(address player_, address router) {
        player = player_;
        tokens[0] = address(new Token(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        tokens[1] = address(new Token(TOKENS_NAME[1], TOKENS_SYMBOL[1]));
        Token(tokens[0]).mint(player_, 10);

        Token(tokens[0]).mint(address(this), 10000000);
        Token(tokens[1]).mint(address(this), 10000000);
        Token(tokens[0]).approve(router, 10000000);
        Token(tokens[1]).approve(router, 10000000);

        address factory = FactoryFacet(msg.sender).deployFactory(player);
        IRouter(router).addLiquidity(tokens[0], tokens[1], 10000000, 10000000, 10000000, 10000000, address(this), block.timestamp, factory);
    }
} 