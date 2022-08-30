// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface ISvgFacet {
    function getLevelRewardSvg(uint256 _levelId, uint256 _type) external view returns (string memory ag_);

    function deploySvg(string calldata _svg) external returns(address contracts);
    function storeSvg(string calldata _svg, uint256 levelId, uint256 _type) external;
    function updateSvg(string calldata _svg, uint256 levelId, uint256 _type) external;
}