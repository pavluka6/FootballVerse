// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";



/**
 * @title FootballVersePlayer
 * @dev Create a sample ERC721 standard token
 */
contract FootballVersePlayer is ERC721, Ownable {
    mapping (uint256 => uint256) public playerToClub;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    Player[] public players;

    string[] public playerNames = ['Lionel', 'Cristiano', 'Luka', 'Kylian', 'Erling'];
    string[] public playerSurnames = ['Messi', 'Ronaldo', 'Modric', 'Mbappe', 'Haaland'];
 
    event PlayerMinted(address indexed _to, uint256 clubId, uint256 playerId);

    struct Player {
        string name;
        string surname;
        uint256 att;
        uint256 mid;
        uint256 def;
        uint256 age;
    }

    constructor(string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {}

    // modifier onlyOwnerOf(uint clubId) {
    //     require(msg.sender == ownerOf(clubId));
    // }

    function createPlayer(address _to, uint256 clubId) external {
        uint playerId = _tokenIds.current();
        uint rId_name = uint(keccak256(abi.encodePacked(block.difficulty, msg.sender)));
        uint rId_surname = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        bytes memory x = abi.encodePacked(block.timestamp, msg.sender);
        Player memory newPlayer = Player(playerNames[rId_name%5], playerSurnames[rId_surname%5], uint(keccak256(x)) % 100, uint(keccak256(x)) % 100, uint(keccak256(x)) % 100, uint(keccak256(x))%17 + 18);
        players.push(newPlayer);
        playerToClub[playerId] = clubId;
        _safeMint(_to, playerId);
        _tokenIds.increment();

        emit PlayerMinted(_to, clubId, playerId);
    }

    function getPlayers() public view returns(Player[] memory) {
        return players;
    }

}