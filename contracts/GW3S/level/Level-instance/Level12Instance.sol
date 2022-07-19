// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/facets/FactoryFacet.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

uint constant MAX = 1e9 * 10 ** 18;
address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level12Instance {
    address public player;
    address[2] tokens;
    string[] public TOKENS_NAME = ["level12 USDC", "level12 GHST"];
    string[] public TOKENS_SYMBOL = ["DAI", "GHST"];
    address public router;
    address[2] public factories;

    constructor(address player_, address router_) {
        player = player_;
        router = router_;

        tokens[0] = address(new Token(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        Token(tokens[0]).mint(player_, 100);
        Token(tokens[0]).mint(address(this), 1e9);
        Token(tokens[0]).approve(router_, MAX);

        tokens[1] = address(new Token(TOKENS_NAME[1], TOKENS_SYMBOL[1]));
        Token(tokens[1]).mint(address(this), 1e9);
        Token(tokens[1]).approve(router_, MAX);

        factories[0] = FactoryFacet(msg.sender).deployFactory(player);
        factories[1] = FactoryFacet(msg.sender).deployFactory(player);

        IRouter(router_).addLiquidity(tokens[0], tokens[1], 1000000 * 1e18, 2000000 * 1e18, 1000000 * 1e18, 2000000 * 1e18, address(this), block.timestamp, factories[0]);
        IRouter(router_).addLiquidity(tokens[0], tokens[1], 1000000 * 1e18, 1000000 * 1e18, 1000000 * 1e18, 1000000 * 1e18, address(this), block.timestamp, factories[1]);
    }

    function getPairs() public returns(address[] memory pair) {
        bytes32 pair0;
        bytes32 pair1;
        address token0 = tokens[0] < tokens[1] ? tokens[0] : tokens[1];
        address token1 = tokens[0] > tokens[1] ? tokens[0] : tokens[1];

        pair0 = keccak256(abi.encodePacked(
            hex'ff',
            factories[0],
            keccak256(abi.encodePacked(token0, token1)),
            IFactory(factories[0]).INIT_CODE_HASH()
        ));
        
        pair1 = keccak256(abi.encodePacked(
            hex'ff',
            factories[1],
            keccak256(abi.encodePacked(token0, token1)),
            IFactory(factories[1]).INIT_CODE_HASH()
        ));

        pair[0] = address(uint160(uint256(pair0)));
        pair[1] = address(uint160(uint256(pair1)));
    }
} 