// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Level-instance/Level7Instance.sol";
import "../Level-instance/interfaces/ILevel7Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level7Facet is Modifiers {

    function initLevel7() external returns(address) {
        Level7Instance instance = new Level7Instance(msg.sender);

        s.level_completed[msg.sender][7] = false;
        s.level_running[msg.sender] = 7;
        s.level_instance[msg.sender][7] = address(instance);

        emit DeployedInstance(7, msg.sender, address(instance));
        return address(instance);
    }

    function completeL7() external hasCompleted(7) isRunning(7) {
        address pair = ILevel7Instance(s.level_instance[msg.sender][7]).getPair();

        uint balance = IERC20(pair).balanceOf(msg.sender);
        require(balance > 0, "level not completed yet");

        s.level_completed[msg.sender][7] = true;
        emit Completed(7, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL7Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(s.level_completed[msg.sender][7] == true, "openL7Chest: You need to complete the level first");
        uint8 i;

        if(_s.level_reward[msg.sender][7] == false) {
            s.level_reward[msg.sender][7] = true;
            IErc721RewardLevel(s.Erc721LevelReward[7][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[7][0];
            amount[i++] = 1;
        }

        emit LootChest(7, msg.sender, loot, amount);
    }

}