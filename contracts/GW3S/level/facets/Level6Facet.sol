// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "../../AMM/interfaces/IToken.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level6Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel6() external returns(address) {
        IToken(s.level_tokens[6][0]).mint(msg.sender, 10);
        IToken(s.level_tokens[6][6]).mint(msg.sender, 1);
        
        s.level_completed[msg.sender][6] = false;
        s.level_running[msg.sender] = 6;
        s.level_instance[msg.sender][6] = address(this);

        emit DeployedInstance(6, msg.sender, address(this));
        return address(this);
    }

    function complete_l6() external hasCompleted(6) isRunning(6) {
        address ghst = s.level_tokens[6][0];
        uint balance = IToken(ghst).balanceOf(msg.sender);

        require(balance >= 10e18, "level not completed yet");
        s.level_completed[msg.sender][6] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l6() external hasClaimed(6) {
        require(s.level_completed[msg.sender][6] == true, "Claim_l6: You need to complete the level first");

        s.level_reward[msg.sender][6] = true;
        IErc721RewardLevel(s.Erc721LevelReward[6][0]).safeMint(msg.sender);
                                                                                          
        emit ClaimReward(0, msg.sender);
    }

    function getTokens() external view returns(address[] memory) {
        return (s.level_tokens[6]);
    }

    function getFactory() external view returns(address) {
        return (s.level_factory[6]);
    }

    function getPair(address token0, address token1) public returns(address pair) {
        bytes32 tmp;
        address tokenA = token0 < token1 ? token0 : token1;
        address tokenB = token0 > token1 ? token0 : token1;

        tmp = keccak256(abi.encodePacked(
            hex'ff',
            s.level_factory[6],
            keccak256(abi.encodePacked(tokenA, tokenB)),
            IFactory(s.level_factory[6]).INIT_CODE_HASH()
        ));

        pair = address(uint160(uint256(tmp)));
    }

}