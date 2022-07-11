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

// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract InitLevel9 {    

    AppStorage internal s;

    function init(address addr_) external {
        s.level[9].addr = addr_;
        s.level[9].id = 9;
        s.level[9].title = "Printer goes bRrRrRrRrRR";
        s.level[9].difficulty = Difficulty.EASY;
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }
}
