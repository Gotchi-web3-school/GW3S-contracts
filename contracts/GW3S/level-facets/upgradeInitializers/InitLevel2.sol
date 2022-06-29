// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibAppStorage, AppStorage} from "../../libraries-facets/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries-facets/LibLevel.sol";

// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract InitLevel2 {    

    AppStorage internal s;

    function init(address addr_) external {
        s.level[2].addr = addr_;
        s.level[2].id = 2;
        s.level[2].title = "Approve";
        s.level[2].difficulty = Difficulty.EASY;
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }
}
