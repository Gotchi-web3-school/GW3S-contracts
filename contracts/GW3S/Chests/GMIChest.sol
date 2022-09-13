// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract GMIChest is IERC721Receiver, Ownable {
    address public ERC721GotchiverseRealm;
    address public ERC721GMIartistSummit;
    bool private _isFull;
    uint256 private _landId;

    event Looted(address indexed looter, address indexed land, uint256 indexed landId);

    constructor(address owner, address erc721GotchiverseRealm) {
        transferOwnership(owner);
        ERC721GotchiverseRealm = erc721GotchiverseRealm;
    }

    fallback() external {
        revert("");
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    //@notice: Only the owner of this chest can deposit item inside
    //@param: The tokenId of a land parcel from https://www.aavegotchi.com/ protocol
    function deposit(uint256 tokenId) public onlyOwner returns(uint256) {
        require(!_isFull, "deposit: Chest is full, can't add more items");
        require(IERC721(ERC721GotchiverseRealm).ownerOf(tokenId) == msg.sender, "deposit: You are not the owner of that NFT");
        require(IERC721(ERC721GotchiverseRealm).getApproved(tokenId) == address(this), "deposit: Land is not approved to this contract");

        IERC721(ERC721GotchiverseRealm).safeTransferFrom(msg.sender, address(this), tokenId, "");
        _landId = tokenId;
        _isFull = true;

        return(tokenId);
    }

    //@notice: Only the owner of this chest and the owner of the ERC721GMIArtistist id=0 can loot the chest
    //@return: the address of looter, the address of the landParcel nft, the id of the parcel  
    function loot() public returns(address[] memory, uint256[] memory) {
        require(msg.sender == owner() || IERC721(ERC721GMIartistSummit).ownerOf(1) == msg.sender,
                "loot: You are not the owner or don't have the GMI NFT id=0");

        address[] memory loots = new address[](1); 
        uint256[] memory amounts = new uint256[](1);

        IERC721(ERC721GotchiverseRealm).safeTransferFrom(address(this), msg.sender, _landId);
        emit Looted(msg.sender, ERC721GotchiverseRealm, _landId);

        _isFull = false;
        loots[0] = ERC721GotchiverseRealm;
        amounts[0] = 1;

        return (loots, amounts);
    }

    function setERC721GMI(address nftContract) external onlyOwner {
        ERC721GMIartistSummit = nftContract;
    }
}