// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";

contract Level1Facet is Modifiers {

    function completeL1() external hasCompleted(1) returns (bool) {
        _s.level_completed[msg.sender][1] = true;
        emit Completed(1, msg.sender);

        return true;
    }
    
    /// @notice Claim reward.
    function openL1Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][1] == true, "openL1Chest: You need to complete the level first");
        address[] memory loots = new address[](1); 
        uint256[] memory amounts = new uint256[](1); 

        if(_s.level_reward[msg.sender][1] == false) {
            _s.level_reward[msg.sender][1] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[1][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[1][0];
            amounts[0] = 1;
        }

        emit LootChest(1, msg.sender, loots, amounts);
        return (loots, amounts);
    }
}