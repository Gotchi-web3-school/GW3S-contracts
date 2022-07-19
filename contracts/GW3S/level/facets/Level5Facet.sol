// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import "../Level-instance/Level5Instance.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level5Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel5() external returns(address) {
        Level5Instance instance = new Level5Instance(msg.sender);
        
        s.level_completed[msg.sender][5] = false;
        s.level_running[msg.sender] = 5;
        s.level_instance[msg.sender][5] = address(this);

        emit DeployedInstance(5, msg.sender, address(this));
        return address(this);
    }

    function complete_l5(address who) external hasCompleted(5) isRunning(5) {
        address instance = s.level_instance[msg.sender][5];
        require(who == address(this) || who == Level5Instance(instance).token(), "Wrong address !");

        if (who == address(this)) {
            Level5Instance(instance).setCompleted(1);
        }
        s.level_completed[msg.sender][5] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l5() external {
        address instance = s.level_instance[msg.sender][5];
        address token = Level5Instance(instance).token_();
        uint8 completed = Level5Instance(instance).completed();

        require(s.level_completed[msg.sender][5] == true, "Claim_l5: You need to complete the level first");

        if (s.level_reward[msg.sender][5] == false && completed == 0) {
            s.level_reward[msg.sender][5] = true;
            IErc721RewardLevel(s.Erc721LevelReward[5][0]).safeMint(msg.sender);
        }
        if (s.secret_reward[msg.sender][5] == false && completed == 1) {
            s.secret_reward[msg.sender][5] = true;
            IErc721RewardLevel(s.Erc721LevelReward[5][1]).safeMint(msg.sender);
        }
        if (s.hacker_reward[msg.sender][5] == false && IERC20(token).balanceOf(msg.sender) >= 10) {
            s.hacker_reward[msg.sender][5] = true;
            IErc721RewardLevel(s.Erc721LevelReward[5][2]).safeMint(msg.sender);
        }

        emit ClaimReward(0, msg.sender);
    }

}