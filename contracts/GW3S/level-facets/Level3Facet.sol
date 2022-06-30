// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Level-instance/Level2Instance.sol";
import {AppStorage, LibAppStorage} from "../libraries-facets/LibAppStorage.sol";
import {Modifiers} from "../libraries-facets/LibLevel.sol";


contract Level2Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployInstance(uint256 indexed level, address indexed player);

    function initLevel() external {
        Level2Instance instance = new Level2Instance(msg.sender);
        s.level_completed[msg.sender][2] = false;
        s.level_running[msg.sender] = 2;
        s.level_instance[msg.sender][2] = address(instance);

        emit DeployInstance(2, msg.sender);
    }

    function complete_l2() external hasCompleted(2) isRunning(2) returns (bool) {
        if (Level2Instance(s.level_instance[msg.sender][2]).isShipped()) {
            s.level_completed[msg.sender][2] = true;
            emit Completed(2, msg.sender);
            return true;
        } else {
            return false;
        }
    }
    
    /// @notice Claim reward.
    function claim_l2() external hasClaimed(2) {
        require(s.level_completed[msg.sender][2] == true, "Claim_l2: You need to complete the level first");

        s.level_reward[msg.sender][2] = true;
        emit ClaimReward(2, msg.sender);
    }
}