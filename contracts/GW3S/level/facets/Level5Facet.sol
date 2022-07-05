// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level5Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel5() external returns(address) {
        Token token = new Token("Who am I ?", "CATCH");
        token.mint(msg.sender, 1);
        
        s.level_completed[msg.sender][5] = false;
        s.level_running[msg.sender] = 5;
        s.level_instance[msg.sender][5] = address(this);

        emit DeployedInstance(5, msg.sender, address(this));
        return address(this);
    }

    function complete_l5(address who) external hasCompleted(5) isRunning(5) {
        require(who == address(this), "Wrong address !");
        s.level_completed[msg.sender][5] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l5() external hasClaimed(5) {
        require(s.level_completed[msg.sender][5] == true, "Claim_l5: You need to complete the level first");
        s.level_reward[msg.sender][5] = true;
        emit ClaimReward(0, msg.sender);
    }

}