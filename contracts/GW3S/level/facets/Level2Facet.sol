// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level2Instance.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level2Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    /// @notice Init the level. This will deploy and set up an instance of the current level.
    function initLevel2() external returns(address) {
        Level2Instance instance = new Level2Instance(msg.sender);
        s.level_completed[msg.sender][2] = false;
        s.level_running[msg.sender] = 2;
        s.level_instance[msg.sender][2] = address(instance);

        emit DeployedInstance(2, msg.sender, address(instance));
        return address(instance);
    }

    /// @notice Complete the level if player think he has filled the requirement(s).
    function complete_l2() external hasCompleted(2) isRunning(2) returns (bool) {
        require(Level2Instance(s.level_instance[msg.sender][2]).shipped(), "level not completed yet");
        s.level_completed[msg.sender][2] = true;
        emit Completed(2, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function claim_l2() external {
        require(s.level_completed[msg.sender][2] == true, "Claim_l2: You need to complete the level first");

        // Give level reward to player. 
        if(s.level_reward[msg.sender][2] == false) {
            s.level_reward[msg.sender][2] = true;
            IErc721RewardLevel(s.Erc721LevelReward[2][0]).safeMint(msg.sender);
        }

        // Give secret reward to player if condition is filled.
        if(s.hacker_reward[msg.sender][2] == false && secretLevel()) {
            s.hacker_reward[msg.sender][2] = true;
            IErc721RewardLevel(s.Erc721LevelReward[2][1]).safeMint(msg.sender);
        }
        
        emit ClaimReward(2, msg.sender);
    }

    /// @notice Check if player has filled the secret level conditions
    function secretLevel() internal view returns(bool) {
        address instance = s.level_instance[msg.sender][2];
        for (uint i; i < 4; i++) {
            address token = Level2Instance(instance).tokens(i);
            uint allowance = IERC20(token).allowance(address(this), msg.sender);

            if (allowance > 0) {
                return false;
            }
        }
        return true;
    }
}