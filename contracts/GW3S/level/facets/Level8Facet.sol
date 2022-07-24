// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level8Instance.sol";
import "../Level-instance/interfaces/ILevel8Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level8Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel8() external returns(address) {
        Level8Instance instance = new Level8Instance(msg.sender, address(this));

        s.level_completed[msg.sender][8] = false;
        s.level_running[msg.sender] = 8;
        s.level_instance[msg.sender][8] = address(instance);

        emit DeployedInstance(8, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l8() external hasCompleted(8) isRunning(8) {
        address DAI = ILevel8Instance(s.level_instance[msg.sender][8]).tokens(1);
        uint256 daiBalance = IERC20(DAI).balanceOf(msg.sender);
        require(daiBalance >= 79 * 10 ** 18 && daiBalance <= 81 * 10 ** 18, "The price quote is higher or lower than expected");

        s.level_completed[msg.sender][8] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l8() external hasClaimed(8) {
        require(s.level_completed[msg.sender][8] == true, "Claim_l8: You need to complete the level first");

        s.level_reward[msg.sender][8] = true;
        IErc721RewardLevel(s.Erc721LevelReward[8][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}