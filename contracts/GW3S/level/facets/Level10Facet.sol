// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level10Instance.sol";
import "../Level-instance/interfaces/ILevel10Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level10Facet is Modifiers {

    function initLevel10() external returns(address) {
        Level10Instance instance = new Level10Instance(msg.sender);

        _s.level_completed[msg.sender][10] = false;
        _s.level_running[msg.sender] = 10;
        _s.level_instance[msg.sender][10] = address(instance);

        emit DeployedInstance(10, msg.sender, address(instance));
        return address(instance);
    }

    function completeL10() external hasCompleted(10) isRunning(10) {
        address usdc = ILevel10Instance(_s.level_instance[msg.sender][10]).tokens(0);
        address ghst = ILevel10Instance(_s.level_instance[msg.sender][10]).tokens(1);
        address pair = ILevel10Instance(_s.level_instance[msg.sender][10]).getPair();

        (uint112 reserve0, uint112 reserve1,) = IPair(pair).getReserves();
        
        uint256 quote = IRouter(address(this)).quote(
            1e18, 
            ghst < usdc ? reserve0 : reserve1, 
            ghst > usdc ? reserve0 : reserve1
            );

        require(quote >= 1000000000e18, "Not billionaire yet !");

        _s.level_completed[msg.sender][10] = true;
        emit Completed(10, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL10Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][10] == true, "openL10Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][10] == false) {
            _s.level_reward[msg.sender][10] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[10][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[10][0];
            amounts[0] = 1;
        }

        emit LootChest(10, msg.sender, loots, amounts);
        return (loots, amounts);
    }

}