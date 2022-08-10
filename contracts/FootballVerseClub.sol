// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FootballVerseClub
 * @dev MVP version of the FootballVerse Club Contract
 */
contract FootballVerseClub is ERC721, Ownable {
    uint256 index;

    struct Club {
        string name;
        uint8 stadium;
        uint8 academy;
    }

    uint256 fee = 1 ether;

    Club[] public clubs;

    event NewClub(address indexed owner, uint256 index);

    constructor(string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {}

    function _createClub(string memory _name) public payable {
        require(msg.value >= fee, "Value sent is lower than the price");
        Club memory newClub = Club(_name, 1, 1);
        clubs.push(newClub);
        _safeMint(msg.sender, index);
        index++;

        emit NewClub(msg.sender, index-1);
    }

    function changeFee(uint256 newFee) external onlyOwner() {
        fee = newFee;
    }

    function withdraw() external payable onlyOwner() {
        address payable owner = payable(owner());
        owner.transfer(address(this).balance);
    }

    function getClubs() public view returns(Club[] memory) {
        return clubs;
    }
}