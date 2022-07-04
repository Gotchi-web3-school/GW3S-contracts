// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import '../../../uniswap/v2-core/contracts/UniswapV2Factory.sol';
import {AppStorage} from "../../libraries/LibAppStorage.sol";

contract FactoryFacet {
    AppStorage internal s;

    function deployFactory(address player) external returns(address) {
        UniswapV2Factory factory = new UniswapV2Factory(player);
        s.factory[player] = address(factory);
        return address(factory);
    }
}