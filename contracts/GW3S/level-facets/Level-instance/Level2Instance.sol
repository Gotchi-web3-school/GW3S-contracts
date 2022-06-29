// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}

contract Level2Instance {
    address player;
    address[4] tokens;
    bool shipped;
    string[] TOKENS_SYMBOL = ["KEK", "ALPHA", "FOMO", "FUD"];
    string[] TOKENS_NAME = ["level2 KEK", "level2 ALPHA", "level2 FOMO", "level2 FUD"];

    constructor(address player_) {
        for (uint i = 0; i < tokens.length; i++) {
            tokens[i] = address(new Token(TOKENS_NAME[i], TOKENS_SYMBOL[i]));
            Token(tokens[i]).mint(player_, 10);
        }
        player = player_;
    }

    function shipTokens() public {
        uint allowance;

        for (uint i = 0; i < tokens.length; i++) {
            allowance = Token(tokens[i]).allowance(msg.sender, address(this));  
            require(allowance >= 10 * 10 ** 18, "Fail: all 4 tokens are not approved");
        }

        for (uint i = 0; i < tokens.length; i++) {
            Token(tokens[i]).transferFrom(msg.sender, address(this), 10 * 10 ** 18);  
        }
        shipped = true;
    }

    function isShipped() external view returns (bool) {
        return shipped;
    }
    
} 