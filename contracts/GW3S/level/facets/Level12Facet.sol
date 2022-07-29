// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../Level-instance/interfaces/ILevel12Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../AMM/interfaces/IToken.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import "../Level-instance/Level12Instance.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level12Facet is Modifiers {
    using SafeMath for uint256;

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel12() external returns(address) {
        Level12Instance instance = new Level12Instance(msg.sender, s.level_factories[12][0], s.level_factories[12][1]);

        s.level_completed[msg.sender][12] = false;
        s.level_running[msg.sender] = 12;
        s.level_instance[msg.sender][12] = address(instance);

        emit DeployedInstance(12, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l12() external hasCompleted(12) isRunning(12) {
        address usdc = ILevel12Instance(s.level_instance[msg.sender][12]).tokens(0);
        require(IToken(usdc).balanceOf(msg.sender) >= 200 * 1e18, "Not suceeded yet");

        s.level_completed[msg.sender][12] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l12() external {
        require(s.level_completed[msg.sender][12] == true, "Claim_l12: You need to complete the level first");

        (address pair1, address pair2) = ILevel12Instance(s.level_instance[msg.sender][12]).getPairs();
        (uint112 reserve00, uint112 reserve10,) = IPair(pair1).getReserves();
        (uint112 reserve01, uint112 reserve11,) = IPair(pair2).getReserves();
        uint256 quote0 = IRouter(address(this)).quote(1e18, reserve00, reserve10);
        uint256 quote1 = IRouter(address(this)).quote(1e18, reserve01, reserve11);


        if(s.level_reward[msg.sender][12] == false) {
            s.level_reward[msg.sender][12] = true;
            IErc721RewardLevel(s.Erc721LevelReward[12][0]).safeMint(msg.sender);
        }
        
        if  (s.secret_reward[msg.sender][12] == false && 
            quote0 >= quote1.mul(99e16).div(1e18) && 
            quote0 <= quote1.mul(11e17).div(1e18)) 
        {
            s.secret_reward[msg.sender][12] = true;
            IErc721RewardLevel(s.Erc721LevelReward[12][1]).safeMint(msg.sender);
        }

        emit ClaimReward(0, msg.sender);
    }

}