// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../../uniswap/v2-core/contracts/libraries/UniswapV2Library.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level8Instance {
    address[2] public tokens;
    address public player;
    string[] public TOKENS_NAME = ["level8 GHST", "level8 DAI"];
    string[] public TOKENS_SYMBOL = ["GHST", "DAI"];
    address public factory;

    constructor(address player_) {
        player = player_;

        for (uint8 i = 0; i < TOKENS_NAME.length; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(player_, 100);
            Token(tokens[i]).mint(address(this), 10);
            Token(tokens[i]).approve(msg.sender, 10e18);
        }
        factory = IFactory(msg.sender).deployFactory(player_);
        IRouter(msg.sender).addLiquidity(tokens[0], tokens[1], 10e18, 10e18, 10e18, 10e18, address(this), block.timestamp, factory);
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
}