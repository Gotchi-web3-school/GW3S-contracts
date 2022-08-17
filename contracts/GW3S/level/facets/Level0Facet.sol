// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level0Facet is Modifiers {

    /// @notice Claim reward.
    function openL0Chest() external returns(address[] memory loot, uint[] memory amount) {
        uint8 i;

        if(_s.level_reward[msg.sender][0] == false) {
            _s.level_reward[msg.sender][0] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[0][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[0][0];
            amount[i++] = 1;
        }

        emit LootChest(0, msg.sender, loot, amount);
    }
} 