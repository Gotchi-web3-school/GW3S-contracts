// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../Level-instance/Level3Instance.sol";
import "../Level-instance/interfaces/ILevel3Instance.sol";
import "../../../uniswap/v2-core/contracts/UniswapV2Factory.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level3Facet is Modifiers {

    function initLevel3() external returns(address) {
        Level3Instance instance = new Level3Instance(msg.sender, address(this), _s.level_factories[3][0]);
        _s.level_completed[msg.sender][3] = false;
        _s.level_running[msg.sender] = 3;
        _s.level_instance[msg.sender][3] = address(instance);

        emit DeployedInstance(3, msg.sender, address(instance));
        return address(instance);
    }

    // TODO: condition to win
    function completeL3() external hasCompleted(3) isRunning(3) returns (bool) {
        address ghst = ILevel3Instance(_s.level_instance[msg.sender][3]).tokens(1);
        uint balance = IERC20(ghst).balanceOf(msg.sender);

        require(balance >= 1, "level not completed yet");

        _s.level_completed[msg.sender][3] = true;
        emit Completed(3, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function openL3Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][3] == true, "openL3Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][3] == false) {
            _s.level_reward[msg.sender][3] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[3][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[3][0];
            amounts[0] = 1;
        }

        emit LootChest(3, msg.sender, loots, amounts);
        return (loots, amounts);
    }
}