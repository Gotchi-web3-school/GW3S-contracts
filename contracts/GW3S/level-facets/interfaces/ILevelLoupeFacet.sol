// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

interface ILevelLoupeFacet {
    function getTitle(uint256 levelId) external view returns (string memory title);
    function getLevelDifficulty(uint256 levelId) external view returns (string memory title);
    function hasCompletedLevel(address account, uint256 levelId) external view returns (bool result);
    function hasClaimedLevel(address account, uint256 levelId) external view returns (bool result);
}
