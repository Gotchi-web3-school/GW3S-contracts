// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISvgStore {
    function deploySvg(string calldata _svg) external returns(address contracts);
}
