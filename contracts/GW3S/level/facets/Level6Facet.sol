// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "../../AMM/interfaces/IToken.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level6Facet is Modifiers {

    function initLevel6() external returns(address) {
        IToken(_s.level_tokens[6][0]).mint(msg.sender, 10);
        IToken(_s.level_tokens[6][6]).mint(msg.sender, 1);
        
        _s.level_completed[msg.sender][6] = false;
        _s.level_running[msg.sender] = 6;
        _s.level_instance[msg.sender][6] = address(this);

        emit DeployedInstance(6, msg.sender, address(this));
        return address(this);
    }

    function completeL6() external hasCompleted(6) isRunning(6) {
        address ghst = _s.level_tokens[6][0];
        uint balance = IToken(ghst).balanceOf(msg.sender);

        require(balance >= 10e18, "level not completed yet");
        _s.level_completed[msg.sender][6] = true;
        emit Completed(6, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL6Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][6] == true, "openL6Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][6] == false) {
            _s.level_reward[msg.sender][6] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[6][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[6][0];
            amounts[0] = 1;
        }
                                                                                          
        emit LootChest(6, msg.sender, loots, amounts);
        return (loots, amounts);
    }

    function getTokens() external view returns(address[] memory) {
        return (_s.level_tokens[6]);
    }

    function getFactory() external view returns(address) {
        return (_s.level_factories[6][0]);
    }

    function getPair(address token0, address token1) public returns(address pair) {
        bytes32 tmp;
        address tokenA = token0 < token1 ? token0 : token1;
        address tokenB = token0 > token1 ? token0 : token1;

        tmp = keccak256(abi.encodePacked(
            hex'ff',
            _s.level_factories[6][0],
            keccak256(abi.encodePacked(tokenA, tokenB)),
            IFactory(_s.level_factories[6][0]).INIT_CODE_HASH()
        ));

        pair = address(uint160(uint256(tmp)));
    }

}