// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DefaultAmmListERC20 is ERC20 {

    constructor(string memory name, string memory ticker) ERC20(name, ticker) {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}