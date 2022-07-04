// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";

enum Difficulty{EASY, MEDIUM, HARD, VERY_HARD, VITALIK}

struct Level {
    address addr;
    uint256 id;
    string title;
    Difficulty difficulty;
}

contract Modifiers {
    AppStorage internal s;

    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }

    modifier hasCompleted(uint256 levelId) {
        require(s.level_completed[msg.sender][levelId] == false, "Level already finished");
        _;
    }

    modifier hasClaimed(uint256 levelId) {
        require(s.level_reward[msg.sender][levelId] == false, "Reward already claimed");
        _;
    }

    modifier isRunning(uint256 levelId) {
        require(s.level_running[msg.sender] == levelId, "You are not running this level actually");
        _;
    }
}