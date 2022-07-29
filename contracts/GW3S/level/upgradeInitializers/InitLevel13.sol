// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibAppStorage, AppStorage} from "../../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries/LibLevel.sol";
import "../../AMM/facets/FactoryFacet.sol";

// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract InitLevel13 {    

    AppStorage internal _s;

    function init(address addr_) external {
        _s.level[13].addr = addr_;
        _s.level[13].id = 13;
        _s.level[13].title = "Kimchi premium";
        _s.level[13].difficulty = Difficulty.MEDIUM;


        address factory1 = FactoryFacet(address(this)).deployFactory(address(this));
        address factory2 = FactoryFacet(address(this)).deployFactory(address(this));
        _s.level_factories[13][0] = factory1;
        _s.level_factories[13][1] = factory2;
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }
}
