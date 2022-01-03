//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Player is ERC721("Player", "PLR") {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address owner = address(0);

    constructor(address gameContractAddress) public {}

    struct Player {
        uint256 tokenId;
        bool exists;
        string name;
        string pfpUrl;
        string pfpName;
        string faction;
        uint256 pfpTokenId;
        bool joined;
        uint256 joinedRoundId;
    }

    struct PlayerInp {
        string name;
        uint256 pfpTokenId;
        string pfpUrl;
        string pfpName;
    }

    mapping(address => Player) public players;
    mapping(address => uint256) public addr2token;

    event PlayerCreated(uint256 tokenId, Player player);

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    function initialize() public {
        require(owner == address(0), "ALREADY_INITIALIZED");
        owner = msg.sender;
    }

    function mint(PlayerInp memory playerInp) external {
        require(!players[msg.sender].exists, "Player already minted");
        _tokenIds.increment();
        uint256 id = _tokenIds.current();
        _mint(msg.sender, id);
        Player storage player = players[msg.sender];
        player.tokenId = id;
        player.name = playerInp.name;
        player.pfpTokenId = playerInp.pfpTokenId;
        player.pfpName = playerInp.pfpName;
        player.pfpUrl = playerInp.pfpUrl;
        // player.faction = playerInp.faction;
        player.exists = true;
        player.joined = false;
        // player.joinedRoundId = 1;
        addr2token[msg.sender] = id;
        emit PlayerCreated(_tokenIds.current(), player);
    }

    function joinGame(uint256 roundId) external {
        require(!players[msg.sender].joined, "Player already joined");
        players[msg.sender].joined = true;
        players[msg.sender].joinedRoundId = roundId;
    }

    function leaveGame() external {
        require(players[msg.sender].joined, "Player already left");
        players[msg.sender].joined = false;
        players[msg.sender].joinedRoundId = 0;
    }

    function getPlayer(uint256 id) public view returns (Player memory) {
        require(_exists(id), "Non-existent player");
        Player storage p = players[ownerOf(id)];
        return p;
    }

    function getTokenId(address addr) public view returns (uint256) {
        return addr2token[addr];
    }
}
