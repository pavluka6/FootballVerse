const Club = artifacts.require("FootballVerseClub");
const Player = artifacts.require("FootballVersePlayer");

module.exports = function (deployer) {
  deployer.deploy(Club, "FootballVerseClub", "FVC");
  deployer.deploy(Player, "FootballVersePlayer", "FVP");
};