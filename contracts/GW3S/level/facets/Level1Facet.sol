// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";

contract Level1Facet is Modifiers {

    function completeL1() external hasCompleted(2) returns (bool) {
        _s.level_completed[msg.sender][1] = true;
        emit Completed(1, msg.sender);

        return true;
    }
    
    /// @notice Claim reward.
    function openL1Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(_s.level_completed[msg.sender][1] == true, "openL1Chest: You need to complete the level first");
        uint8 i;

        if(_s.level_reward[msg.sender][1] == false) {
            _s.level_reward[msg.sender][1] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[1][0]).safeMint(msg.sender);


            loot[i] = _s.Erc721LevelReward[1][0];
            amount[i++] = 1;
        }

        emit LootChest(1, msg.sender, loot, amount);
    }
}