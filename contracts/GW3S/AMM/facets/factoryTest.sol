// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import '../../../uniswap/v2-core/contracts/UniswapV2Factory.sol';

contract FactoryTest {

    function deployFactory(address player) external returns(address) {
        UniswapV2Factory factory = new UniswapV2Factory(player);
        return address(factory);
    }

}