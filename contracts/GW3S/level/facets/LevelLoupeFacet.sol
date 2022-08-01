// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {LibAppStorage, AppStorage} from "../../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries/LibLevel.sol";

contract LevelLoupeFacet {
    AppStorage internal _s;

    function getAddress(uint256 levelId) external view returns (address addr) {
        addr = _s.level[levelId].addr;
    }

    function getTitle(uint256 levelId) external view returns (string memory title) {
        title = _s.level[levelId].title;
    }

    function getLevelDifficulty(uint256 levelId) external view returns (Difficulty difficulty) {
        difficulty = _s.level[levelId].difficulty;
    }

    function hasCompletedLevel(address account, uint256 levelId) external view returns (bool result) {
        result = _s.level_completed[account][levelId];
    }

    function hasClaimedLevel(address account, uint256 levelId) external view returns (bool result) {
        result = _s.level_reward[account][levelId];
    }

    function getRunningLevel(address account) external view returns (uint256 result) {
        result = _s.level_running[account];
    }

    function getLevelInstanceByAddress(address account, uint256 levelId) external view returns (address result) {
        result = _s.level_instance[account][levelId];
    }

    function getFactoryLevel(uint256 levelId, uint8 pos) external view returns (address result) {
        result = _s.level_factories[levelId][pos];
    }

    function getTokensLevel(uint256 levelId) external view returns (address[] memory result) {
        result = _s.level_tokens[levelId];
    }
}