// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";


/**
 * @title FootballVerseClub
 * @dev MVP version of the FootballVerse Club Contract
 */

interface PlayerInterface {
  function createPlayer(address _to, uint256 clubId) external;
}

contract FootballVerseClub is ERC721, Ownable {   
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address playerContractAddress;
    uint8 upgradeAcademyFee = 1 ether;
    uint8 upgradeStadiumFee = 1 ether;

    struct Club {
        string name;
        uint8 stadium;
        uint8 academy;
        bool initialized;
    }

    uint256 fee = 1 ether;

    Club[] public clubs;

    event NewClub(address indexed owner, uint256 index);
    event FirstPlayersMinted(address indexed owner, uint256 index);

    PlayerInterface playerContract;

    constructor(string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {}

    function _createClub(string memory _name) public payable {
        clubId = _tokenIds.current();
        require(msg.value >= fee, "Value sent is lower than the price");
        Club memory newClub = Club(_name, 1, 1, false);
        clubs.push(newClub);
        _safeMint(msg.sender, clubId);
        _tokenIds.increment();

        emit NewClub(msg.sender, clubId);
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

    function getOwnerClubs(address _owner) public view returns (Club[] memory) {
        Club[] memory result = new Club[](balanceOf(_owner));
        uint8 counter = 0;

        for(uint256 i=0; i < clubs.length; i++) {
            if(ownerOf(i) == _owner) {
                result[counter] = clubs[i];
                counter++;
            }
        }

        return result;
    }

    function changeClubName(uint256 indexOf, string memory _name) external {
        require(ownerOf(indexOf) == msg.sender);
        clubs[indexOf].name = _name;
    }

     function setPlayerContractAddress(address _address) external onlyOwner {
        playerContractAddress = _address;
        playerContract = PlayerInterface(playerContractAddress);
    }

    function mintFirstPlayers(uint256 clubId) public {
        require(msg.sender == ownerOf(clubId), "Caller is not the owner of the clubId");
        require(!clubs[clubId].initialized, "First batch of players already minted");
        for (uint i = 0; i < 16; i++) { 
            playerContract.createPlayer(msg.sender, clubId);
        }

        clubs[clubId].initialized = true;
        emit FirstPlayersMinted(msg.sender, clubId);
    }

    function _upgradeStadiumFee(uint8 _newfee) external onlyOwner {
        upgradeStadiumFee = _newfee;
    }

    function _upgradeAcademyFee(uint8 _newfee) external onlyOwner {
        upgradeAcademyFee = _newfee;
    }
}