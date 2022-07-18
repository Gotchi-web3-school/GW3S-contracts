// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface ISvg {
    function getLevelRewardSvg(uint256 _levelId, uint256 _type) external view returns (string memory ag_);

    function storeSvg(string calldata _svg, uint256 levelId, uint256 _type) external;
    function updateSvg(string calldata _svg, uint256 levelId, uint256 _type) external;
}