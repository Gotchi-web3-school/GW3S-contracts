// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import '../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol';

address constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;
uint256 constant MAX = 25 * 10 ** 18;

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level9Instance {
    address[2] public tokens;
    address public player;
    string[] public TOKENS_NAME = ["level9 USDC"];
    string[] public TOKENS_SYMBOL = ["USDC"];
    address factory;

    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    constructor(address player_) {
        player = player_;

        tokens[0] = address(new Token(TOKENS_NAME[0], TOKENS_SYMBOL[0]));
        Token(tokens[0]).mint(player_, MAX * 10);
        factory = IFactory(msg.sender).deployFactory(player_);
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

    function deployToken(string memory name, string memory ticker, uint256 totalSupply) public {
        Token token = new Token(name, ticker);
        token.mint(msg.sender, totalSupply);
        tokens[1] = address(token);

        emit Deployed(name, ticker, totalSupply);
    }
}