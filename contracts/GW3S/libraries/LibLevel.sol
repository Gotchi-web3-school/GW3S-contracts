// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {LibAppStorage, AppStorage, SvgStorage} from "./LibAppStorage.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";

enum Difficulty{EASY, MEDIUM, HARD, VERY_HARD, VITALIK}

struct Level {
    address addr;
    uint256 id;
    string title;
    Difficulty difficulty;
}

contract Modifiers {
    AppStorage internal _s;

    event LootChest(uint256 indexed level, address indexed player, address[] indexed loot, uint[] amount);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }

    modifier hasCompleted(uint256 levelId) {
        require(_s.level_completed[msg.sender][levelId] == false, "Level already finished");
        _;
    }

    modifier isRunning(uint256 levelId) {
        require(_s.level_running[msg.sender] == levelId, "You are not running this level actually");
        _;
    }
}