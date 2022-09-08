// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Soulbound is ERC721URIStorage{

    using Counters for Counters.Counter;
    address owner; // only he will give degrees
    mapping(address => bool) public issuedDegrees;
    Counters.Counter private _tokenIds;
    address public user = msg.sender;

    constructor() ERC721("SoulBound", "SBT"){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function issueDegree(address to) external returns(bool){
        issuedDegrees[to] = true;
        return issuedDegrees[to];
    }

    function claimDegree(string memory tokenURI) public returns(uint256){
        
        require(issuedDegrees[msg.sender], "Degree is not issused");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        personToDegree[msg.sender] = tokenURI;
        issuedDegrees[msg.sender] = false;

        return newItemId;
    }

    mapping(address => string) public personToDegree; // for others to see the isueed degree
}
