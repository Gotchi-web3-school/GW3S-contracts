// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Level-instance/Level7Instance.sol";
import "../Level-instance/interfaces/ILevel7Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level7Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel7() external returns(address) {
        Level7Instance instance = new Level7Instance(msg.sender);

        s.level_completed[msg.sender][7] = false;
        s.level_running[msg.sender] = 7;
        s.level_instance[msg.sender][7] = address(instance);

        emit DeployedInstance(7, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l7() external hasCompleted(7) isRunning(7) {
        bytes32 tmp;
        address token0 = ILevel7Instance(s.level_instance[msg.sender][7]).tokens(0);
        address token1 = ILevel7Instance(s.level_instance[msg.sender][7]).tokens(1);
        address pair = ILevel7Instance(s.level_instance[msg.sender][7]).getPair();

        uint balance = IERC20(pair).balanceOf(msg.sender);
        require(balance > 0, "level not completed yet");

        s.level_completed[msg.sender][7] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l7() external hasClaimed(7) {
        require(s.level_completed[msg.sender][7] == true, "Claim_l7: You need to complete the level first");
        s.level_reward[msg.sender][7] = true;
        emit ClaimReward(0, msg.sender);
    }

}