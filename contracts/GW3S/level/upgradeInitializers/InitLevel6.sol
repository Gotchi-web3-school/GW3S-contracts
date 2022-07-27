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
import "../../AMM/interfaces/IToken.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IFactory.sol";

uint constant MAX = 100000000000 * 10 ** 18;
// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract InitLevel6 {    

    AppStorage internal s;

    function init(address addr_, address[] memory tokens, address factory) external {
        // TOKENS_NAME = ["level6 GHST", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI"];
        // TOKENS_SYMBOL = ["GHST, ""DAI", "DAI", "DAI", "DAI", "DAI", "DAI"];

        s.level[6].addr = addr_;
        s.level[6].id = 6;
        s.level[6].title = "Where is WalDAI ?";
        s.level[6].difficulty = Difficulty.EASY;

        s.level_factory[6] = factory;
        s.level_tokens[6] = tokens;
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }
}
