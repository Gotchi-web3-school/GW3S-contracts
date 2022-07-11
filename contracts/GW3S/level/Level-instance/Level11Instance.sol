// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../../uniswap/v2-core/contracts/libraries/SafeMath.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;
uint256 constant MAX = 1000000000 * 10 ** 18;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level11Instance {
    using SafeMath for uint256;

    address[2] public tokens;
    address public player;
    bool public success;
    string[] public TOKENS_NAME = ["level11 DAI", "level11 GHST"];
    string[] public TOKENS_SYMBOL = ["DAI", "GHST"];
    address factory;
    address router;

    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    constructor(address player_, address router_) {
        player = player_;
        router = router_;
        for (uint8 i = 0; i < TOKENS_NAME.length; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(player_, MAX);
            Token(tokens[i]).mint(address(this), 1e18);
            Token(tokens[i]).approve(router_, 1e18);
        }
        factory = IFactory(msg.sender).deployFactory(player_);
        IRouter(router_).addLiquidity(tokens[0], tokens[1], 1e18, 1e18, 1e18, 1e18, address(this), block.timestamp, factory);
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

    function swap(uint amountIn, uint amountOutMin, address[] calldata path) public returns(bool) {
        // get actual quote
        uint256 prevQuote = getQuote();

        // do swap
        IRouter(router).swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp, factory);

        // get new quote
        uint256 currQuote = getQuote();

        // compare new quote
        if (currQuote.mul(10000) / prevQuote >= 9900 && currQuote.mul(10000) / prevQuote <= 10100) {
            success = true;
        }
        return success;
    }

    function getQuote() public returns(uint256 quote) {
        (uint112 reserve0, uint112 reserve1, ) = IPair(getPair()).getReserves();
        quote = IRouter(router).quote(1e18, reserve0, reserve1);
    }
}