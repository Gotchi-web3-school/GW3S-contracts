// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level2Instance.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level2Facet is Modifiers {

    /// @notice Init the level. This will deploy and set up an instance of the current level.
    function initLevel2() external returns(address) {
        Level2Instance instance = new Level2Instance(msg.sender);
        _s.level_completed[msg.sender][2] = false;
        _s.level_running[msg.sender] = 2;
        _s.level_instance[msg.sender][2] = address(instance);

        emit DeployedInstance(2, msg.sender, address(instance));
        return address(instance);
    }

    /// @notice Complete the level if player think he has filled the requirement(_s).
    function completeL2() external hasCompleted(2) isRunning(2) returns (bool) {
        require(Level2Instance(_s.level_instance[msg.sender][2]).shipped(), "level not completed yet");
        _s.level_completed[msg.sender][2] = true;
        emit Completed(2, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function openL2Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(_s.level_completed[msg.sender][2] == true, "openL2Chest: You need to complete the level first");
        uint8 i;

        // Give level reward to player. 
        if(_s.level_reward[msg.sender][2] == false) {
            _s.level_reward[msg.sender][2] = true;
            IErc721RewardLevel(_s.Erc721LevelReward[2][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[2][0];
            amount[i++] = 1;
        }

        // Give secret reward to player if condition is filled.
        if(_s.hacker_reward[msg.sender][2] == false && _secretLevel()) {
            _s.hacker_reward[msg.sender][2] = true;
            IErc721RewardLevel(_s.Erc721LevelReward[2][1]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[2][1];
            amount[i++] = 1;
        }
        
        emit LootChest(2, msg.sender, loot, amount);
    }

    /// @notice Check if player has filled the secret level conditions
    function _secretLevel() internal view returns(bool) {
        address instance = _s.level_instance[msg.sender][2];
        for (uint i; i < 4; i++) {
            address token = Level2Instance(instance).tokens(i);
            uint allowance = IERC20(token).allowance(msg.sender, _s.level_instance[msg.sender][2]);

            if (allowance > 0) {
                return false;
            }
        }
        return true;
    }
}