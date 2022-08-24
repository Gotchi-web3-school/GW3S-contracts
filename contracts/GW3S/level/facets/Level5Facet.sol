// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import "../Level-instance/Level5Instance.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level5Facet is Modifiers {

    function initLevel5() external returns(address) {
        Level5Instance instance = new Level5Instance(msg.sender);
        
        _s.level_completed[msg.sender][5] = false;
        _s.level_running[msg.sender] = 5;
        _s.level_instance[msg.sender][5] = address(instance);

        emit DeployedInstance(5, msg.sender, address(this));
        return address(this);
    }

    function completeL5() external hasCompleted(5) isRunning(5) {
        address instance = _s.level_instance[msg.sender][5];
        address guess = Level5Instance(instance).guess();
        require(guess == _s.level_instance[msg.sender][5] || guess == Level5Instance(instance).token_(), "Wrong address !");

        if (guess == _s.level_instance[msg.sender][5]) {
            Level5Instance(instance).setCompleted(1);
        }
        _s.level_completed[msg.sender][5] = true;
        Level5Instance(instance).clean();

        emit Completed(5, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL5Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][5] == true, "openL5Chest: You need to complete the level first");
        address instance = _s.level_instance[msg.sender][5];
        address token = Level5Instance(instance).token_();
        uint8 completed = Level5Instance(instance).completed();
        uint8 i;
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 


        if (_s.level_reward[msg.sender][5] == false && completed == 0) {
            _s.level_reward[msg.sender][5] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[5][0]).safeMint(msg.sender);

            loots[i] = _s.Erc721LevelReward[5][0];
            amounts[i++] = 1;
        }

        if (_s.secret_reward[msg.sender][5] == false && completed == 1) {
            _s.secret_reward[msg.sender][5] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[5][1]).safeMint(msg.sender);

            loots[i] = _s.Erc721LevelReward[5][1];
            amounts[i++] = 1;
        }
        if (_s.hacker_reward[msg.sender][5] == false && IERC20(token).balanceOf(msg.sender) >= 10e18) {
            _s.hacker_reward[msg.sender][5] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[5][2]).safeMint(msg.sender);

            loots[i] = _s.Erc721LevelReward[5][2];
            amounts[i] = 1;
        }

        emit LootChest(5, msg.sender, loots, amounts);
        return (loots, amounts);
    }

}