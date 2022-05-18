// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import {LibAppStorage, AppStorage} from "../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../libraries/LibLevel.sol";

contract LevelLoupeFacet {
    AppStorage internal s;

    function getAddress(uint256 levelId) external view returns (address addr) {
        addr = s.level[levelId].addr;
    }

    function getTitle(uint256 levelId) external view returns (string memory title) {
        title = s.level[levelId].title;
    }

    function getLevelDifficulty(uint256 levelId) external view returns (Difficulty difficulty) {
        difficulty = s.level[levelId].difficulty;
    }

    function hasCompletedLevel(address account, uint256 levelId) external view returns (bool result) {
        result = s.level_completed[account][levelId];
    }

    function hasClaimedLevel(address account, uint256 levelId) external view returns (bool result) {
        result = s.level_reward[account][levelId];
    }
}