// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {Level} from "./LibLevel.sol";

struct AppStorage {
    // levels (level) state variable
    mapping(uint256 => Level) level;                                    // Store Level by his id  
    mapping(address => mapping(uint256 => bool)) level_completed;       // Store level completed by player and Id of the level
    mapping(address => mapping(uint256 => bool)) level_reward;          // Store level reward by address and Id of the level; return true if claimed
    mapping(address => mapping(uint256 => bool)) secret_reward;         // Store level reward by address and Id of the level; return true if claimed
    mapping(address => mapping(uint256 => bool)) hacker_reward;         // Store level reward by address and Id of the level; return true if claimed
    mapping(address => uint256) level_running;                          // The current level that player try to solve
    mapping(address => mapping(uint256 => address)) level_instance;     // The current instance of player deployed by the a specific level 
    // type = enum{LEVEL, HIDDEN, HACKER}
    mapping(uint => mapping(uint => address)) Erc721LevelReward;            // Store ERC721 smart contract by (levelId => type => svgContract)

    // AMM state
    address router;                                 // The address of the router facet
}

struct SvgStorage {
    // type = enum{LEVEL, HIDDEN, HACKER}
    mapping(uint => mapping(uint => address)) svgLevelReward;            // Store svgs by (levelId => type => svgContract)
}


library LibAppStorage {
    bytes32 constant DIAMOND_SVG_STORAGE_POSITION = keccak256("diamond.standard.diamond.svgStorage");
    bytes32 constant DIAMOND_REWARD_STORAGE_POSITION = keccak256("diamond.standard.diamond.rewardStorage");

    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    function svgDiamondStorage() internal pure returns (SvgStorage storage ds) {
        bytes32 position = DIAMOND_SVG_STORAGE_POSITION;

        assembly {
            ds.slot := position
        }
    }
}

