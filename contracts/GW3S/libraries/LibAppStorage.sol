// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {Level} from "./LibLevel.sol";

struct AppStorage {
    // levels (level) state variable
    mapping(uint256 => Level) level;                                // Find title with the id of a level 
    mapping(address => mapping(uint256 => bool)) level_completed;   // Find level completed by address and Id of the level
    mapping(address => mapping(uint256 => bool)) level_reward;      // Find level reward by address and Id of the level
    mapping(address => uint256) level_running;                      // The current level that anon try to solve 
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}

