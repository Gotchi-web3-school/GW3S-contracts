// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level12Instance.sol";
import "../Level-instance/interfaces/ILevel12Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level12Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel12() external returns(address) {
        Level12Instance instance = new Level12Instance(msg.sender, s.router);

        s.level_completed[msg.sender][12] = false;
        s.level_running[msg.sender] = 12;
        s.level_instance[msg.sender][12] = address(instance);

        emit DeployedInstance(12, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l12() external hasCompleted(12) isRunning(12) {
        address usdc = ILevel12Instance(s.level_instance[msg.sender][12]).tokens(0);
        require(IERC20(usdc).balanceOf(msg.sender) >= 200 * 1e18, "Not suceeded yet");

        s.level_completed[msg.sender][12] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l12() external {
        require(s.level_completed[msg.sender][12] == true, "Claim_l12: You need to complete the level first");
        address[] memory pairs = ILevel12Instance(s.level_instance[msg.sender][12]).getPairs();
        (uint112 reserve00, uint112 reserve10,) = IPair(pairs[0]).getReserves();
        (uint112 reserve01, uint112 reserve11,) = IPair(pairs[1]).getReserves();
        uint quote0 = IRouter(s.router).quote(1e18, reserve00, reserve10);
        uint quote1 = IRouter(s.router).quote(1e18, reserve01, reserve11);


        if(s.level_reward[msg.sender][12] == false) {
            s.level_reward[msg.sender][12] = true;
            IErc721RewardLevel(s.Erc721LevelReward[12][0]).safeMint(msg.sender);
        }
        if(s.secret_reward[msg.sender][12] == false && quote0 == quote1) {
            s.secret_reward[msg.sender][12] = true;
            IErc721RewardLevel(s.Erc721LevelReward[12][1]).safeMint(msg.sender);
        }

        emit ClaimReward(0, msg.sender);
    }

}