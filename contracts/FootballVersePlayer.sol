// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FootballVersePlayer
* @dev MVP version of the FootballVerse Club Contract
 */
contract FootballVersePlayer is ERC721, Ownable {
    uint256 index = 0;

    struct Player {
        string name;
        string surname;
        uint8 att;
        uint8 mid;
        uint8 def;
        uint8 age;
    }

    constructor(string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {}

    function mintPlayer(address _to) public payable {
        _safeMint(_to, index);
        index+=1;
    }
}