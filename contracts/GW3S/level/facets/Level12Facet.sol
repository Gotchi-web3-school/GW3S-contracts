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

    function initLevel12() external returns(address) {
        Level12Instance instance = new Level12Instance(msg.sender, _s.level_factories[12][0], _s.level_factories[12][1]);

        _s.level_completed[msg.sender][12] = false;
        _s.level_running[msg.sender] = 12;
        _s.level_instance[msg.sender][12] = address(instance);

        emit DeployedInstance(12, msg.sender, address(instance));
        return address(instance);
    }

    function completeL12() external hasCompleted(12) isRunning(12) {
        address usdc = ILevel12Instance(_s.level_instance[msg.sender][12]).tokens(0);
        require(IToken(usdc).balanceOf(msg.sender) >= 200 * 1e18, "Not suceeded yet");

        _s.level_completed[msg.sender][12] = true;
        emit Completed(12, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL12Chest() external returns(address[] memory loot, uint[] memory amount) {
        require(_s.level_completed[msg.sender][12] == true, "openL12Chest: You need to complete the level first");
        uint8 i;

        (address pair1, address pair2) = ILevel12Instance(_s.level_instance[msg.sender][12]).getPairs();
        (uint112 reserve00, uint112 reserve10,) = IPair(pair1).getReserves();
        (uint112 reserve01, uint112 reserve11,) = IPair(pair2).getReserves();
        uint256 quote0 = IRouter(address(this)).quote(1e18, reserve00, reserve10);
        uint256 quote1 = IRouter(address(this)).quote(1e18, reserve01, reserve11);


        if(_s.level_reward[msg.sender][12] == false) {
            _s.level_reward[msg.sender][12] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[12][0]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[12][0];
            amount[i++] = 1;
        }
        
        if  (_s.secret_reward[msg.sender][12] == false && 
            quote0 >= quote1.mul(99e16).div(1e18) && 
            quote0 <= quote1.mul(11e17).div(1e18)) 
        {
            _s.secret_reward[msg.sender][12] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[12][1]).safeMint(msg.sender);

            loot[i] = _s.Erc721LevelReward[12][1];
            amount[i++] = 1;
        }

        emit LootChest(12, msg.sender, loot, amount);
    }

}