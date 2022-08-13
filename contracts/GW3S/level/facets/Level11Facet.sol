// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level11Instance.sol";
import "../Level-instance/interfaces/ILevel11Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level11Facet is Modifiers {

    function initLevel11() external returns(address) {
        Level11Instance instance = new Level11Instance(msg.sender, address(this));
        _s.level_completed[msg.sender][11] = false;
        _s.level_running[msg.sender] = 11;
        _s.level_instance[msg.sender][11] = address(instance);

        emit DeployedInstance(11, msg.sender, address(instance));
        return address(instance);
    }

    function completeL11() external hasCompleted(11) isRunning(11) {
        require(ILevel11Instance(_s.level_instance[msg.sender][11]).success(), "Not suceeded yet");

        _s.level_completed[msg.sender][11] = true;
        emit Completed(11, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL11Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(_s.level_completed[msg.sender][11] == true, "openL11Chest: You need to complete the level first");
        uint8 i;

        if(_s.level_reward[msg.sender][11] == false) {
            _s.level_reward[msg.sender][11] = true;
            IErc721RewardLevel(_s.Erc721LevelReward[11][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[11][0];
            amount[i++] = 1;
        }

        emit LootChest(11, msg.sender, loot, amount);
    }

}