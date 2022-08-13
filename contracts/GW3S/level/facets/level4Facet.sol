// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level4Instance.sol";
import "../Level-instance/interfaces/ILevel4Instance.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level4Facet is Modifiers {

    function initLevel4() external returns(address) {
        Level4Instance instance = new Level4Instance(msg.sender, _s.level_factories[4][0]);
        
        _s.level_completed[msg.sender][4] = false;
        _s.level_running[msg.sender] = 4;
        _s.level_instance[msg.sender][4] = address(instance);

        emit DeployedInstance(4, msg.sender, address(instance));
        return address(instance);
    }

    function completeL4() external hasCompleted(4) isRunning(4) returns (bool) {
        address ghst = ILevel4Instance(_s.level_instance[msg.sender][4]).tokens(0);
        uint balance = IERC20(ghst).balanceOf(msg.sender);

        require(balance >= 1, "level not completed yet");
        _s.level_completed[msg.sender][4] = true;
        emit Completed(4, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function openL4Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(_s.level_completed[msg.sender][4] == true, "openL4Chest: You need to complete the level first");
        uint8 i;

        if(_s.level_reward[msg.sender][4] == false) {
            _s.level_reward[msg.sender][4] = true;
            IErc721RewardLevel(_s.Erc721LevelReward[4][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[4][0];
            amount[i++] = 1;
        }

        emit LootChest(4, msg.sender, loot, amount);
    }
}