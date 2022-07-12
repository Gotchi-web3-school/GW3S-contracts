// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/facets/FactoryFacet.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;
uint256 constant MAX = 100 * 1e18;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level13Instance {
    address[2] public tokens;
    address[2] public factories;
    address public player;
    address public router;
    address public diamond;
    string[] public TOKENS_NAME = ["level13 USDC", "level13 GHST"];
    string[] public TOKENS_SYMBOL = ["USDC", "GHST"];

    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    constructor(address player_, address router_) {
        player = player_;
        router = router_;
        diamond = msg.sender;

        // USDC token
        tokens[0] = address(new Token(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        Token(tokens[0]).mint(player_, 1000);
        Token(tokens[0]).mint(address(this), 100);
        Token(tokens[0]).approve(router_, MAX);

        // GHST token
        tokens[1] = address(new Token(TOKENS_NAME[1], TOKENS_SYMBOL[1]));
        Token(tokens[1]).mint(player_, 1000);
        Token(tokens[1]).mint(address(this), 100);
        Token(tokens[1]).approve(router_, MAX);

        factories[0] = FactoryFacet(msg.sender).deployFactory(player);

        IRouter(router_).addLiquidity(tokens[0], tokens[1], MAX, MAX, MAX, MAX, address(this), block.timestamp, factories[0]);
    }

    function getPair(address factory) public returns(address pair) {
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

    function deployFactory() public returns(address) {
        factories[1] = FactoryFacet(diamond).deployFactory(player);
        return factories[1];
    }
}