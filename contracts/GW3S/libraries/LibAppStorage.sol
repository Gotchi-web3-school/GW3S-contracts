// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {Level} from "./LibLevel.sol";

struct AppStorage {
    // levels (level) state variable
    mapping(uint256 => Level) level;                                    // Store Level by his id  
    mapping(address => mapping(uint256 => bool)) level_completed;       // Store level completed by player and Id of the level
    mapping(address => mapping(uint256 => bool)) level_reward;          // Store level reward by address and Id of the level
    mapping(address => uint256) level_running;                          // The current level that player try to solve
    mapping(address => mapping(uint256 => address)) level_instance;     // The current instance of player deployed by the a specific level 
    mapping(address => address) factory;                                // The address of factory deployed by player

    // AMM state
    address router;                                 // The address of the router facet
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}

