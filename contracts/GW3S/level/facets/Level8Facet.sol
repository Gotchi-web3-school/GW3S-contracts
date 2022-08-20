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

    function initLevel8() external returns(address) {
        Level8Instance instance = new Level8Instance(msg.sender);

        _s.level_completed[msg.sender][8] = false;
        _s.level_running[msg.sender] = 8;
        _s.level_instance[msg.sender][8] = address(instance);

        emit DeployedInstance(8, msg.sender, address(instance));
        return address(instance);
    }

    function completeL8() external hasCompleted(8) isRunning(8) {
        uint256 quote = _getQuote();
        require(quote >= 38e17 && quote <= 42e17, "The price quote is higher or lower than expected");

        _s.level_completed[msg.sender][8] = true;
        emit Completed(8, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL8Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][8] == true, "openL8Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][8] == false) {
            _s.level_reward[msg.sender][8] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[8][0]).safeMint(msg.sender);

            loot[0] = _s.Erc721LevelReward[8][0];
            amount[0] = 1;
        }

        emit LootChest(8, msg.sender, loots, amounts);
        return (loots, amounts);
    }

    function _getQuote() internal returns(uint256 quote){
        address ghst = ILevel8Instance(_s.level_instance[msg.sender][8]).tokens(0);
        address dai = ILevel8Instance(_s.level_instance[msg.sender][8]).tokens(1);
        address pair = ILevel8Instance(_s.level_instance[msg.sender][8]).getPair();
        
        (uint256 reserves0, uint256 reserves1, ) = IPair(pair).getReserves();
        uint256 ghstReserves = ghst < dai ? reserves0 : reserves1;
        uint256 daiReserves = dai < ghst ? reserves0 : reserves1;

        quote = IRouter(address(this)).quote(1e18, ghstReserves, daiReserves);
    } 

}