// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level2Instance.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level2Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel2() external returns(address) {
        Level2Instance instance = new Level2Instance(msg.sender);
        s.level_completed[msg.sender][2] = false;
        s.level_running[msg.sender] = 2;
        s.level_instance[msg.sender][2] = address(instance);

        emit DeployedInstance(2, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l2() external hasCompleted(2) isRunning(2) returns (bool) {
        require(Level2Instance(s.level_instance[msg.sender][2]).shipped(), "level not completed yet");
        s.level_completed[msg.sender][2] = true;
        emit Completed(2, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function claim_l2() external hasClaimed(2) {
        require(s.level_completed[msg.sender][2] == true, "Claim_l2: You need to complete the level first");

        s.level_reward[msg.sender][2] = true;
        emit ClaimReward(2, msg.sender);
    }
}