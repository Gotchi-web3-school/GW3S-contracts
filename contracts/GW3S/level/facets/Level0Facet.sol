// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level0Facet is Modifiers {

    /// @notice Claim reward.
    function openL0Chest() external returns(address[] memory, uint[] memory) {
        address[] memory loots = new address[](1); 
        uint256[] memory amounts = new uint256[](1); 

        if(_s.level_reward[msg.sender][0] == false) {
            _s.level_reward[msg.sender][0] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[0][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[0][0];
            amounts[0] = 1;
        }

        emit LootChest(0, msg.sender, loots, amounts);
        return (loots, amounts);
    }
} 