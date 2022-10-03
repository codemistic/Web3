// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

import "hardhat/console.sol";


contract DynamicNFT is ERC721, ERC721Enumerable, ERC721URIStorage, KeeperCompatibleInterface, Ownable  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    AggregatorV3Interface public priceFeed;
 
    uint public /* immutable */ interval; 
    uint public lastTimeStamp;
    uint public indexCounter;

    uint256 public currentPrice;
    
    string[3] bullUrisIpfs = [
        "https://ipfs.io/ipfs/Qmc3ueexsATjqwpSVJNxmdf2hStWuhSByHtHK5fyJ3R2xb?filename=simple_bull.json",
        "https://ipfs.io/ipfs/QmRsTqwTXXkV8rFAT4XsNPDkdZs5WxUx9E5KwFaVfYWjMv?filename=party_bull.json",
        "https://ipfs.io/ipfs/QmS1v9jRYvgikKQD6RrssSKiBTBH3szDK6wzRWF4QBvunR?filename=gamer_bull.json"
    ];

    string[3] bearUrisIpfs = [
        "https://ipfs.io/ipfs/QmZVfjuDiUfvxPM7qAvq8Umk3eHyVh7YTbFon973srwFMD?filename=simple_bear.json",
        "https://ipfs.io/ipfs/QmP2v34MVdoxLSFj1LbGW261fvLcoAsnJWHaBK238hWnHJ?filename=coolio_bear.json",
        "https://ipfs.io/ipfs/QmQMqVUHjCAxeFNE9eUxf89H1b7LpdzhvQZ8TXnj4FPuX1?filename=beanie_bear.json"
    ];

    event TokensUpdated(string marketTrend);

    constructor(uint updateInterval) ERC721("Bull&Bear", "BBTK") {
        interval = updateInterval; 
        lastTimeStamp = block.timestamp; 
        priceFeed = AggregatorV3Interface(0xECe365B379E1dD183B20fc5f022230C044d51404);
        currentPrice = uint256(getLatestPrice());
    }

    function safeMint(address to) public  {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        string memory defaultUri = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);
    }

    function updateAllTokenUris(bool higherCheck) internal {
        uint index = indexCounter % 3; // 0, 1, 2
        indexCounter++;

        if (higherCheck) {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i, bullUrisIpfs[index]);
            }  
        }
        else {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i, bearUrisIpfs[index]);
            } 
        }   
        emit TokensUpdated(higherCheck ? "BULL" : "BEAR");
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /*performData */) {
         upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;

    }

    function performUpkeep(bytes calldata /* performData */ ) external override {
        require(((block.timestamp - lastTimeStamp) > interval), "Second upkeep check failed! impossible!!!");

        lastTimeStamp = block.timestamp;         
        uint256 latestPrice =uint256(getLatestPrice());
    
        if (latestPrice == currentPrice) {
            return;
        }
        else if (latestPrice < currentPrice) {
            updateAllTokenUris(false);

        } else {
            updateAllTokenUris(true);
        }

        currentPrice = latestPrice;
    }

    function getLatestPrice() public view returns (int256) {
         (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        return price;
    }

  
    function updateInterval(uint256 newInterval) public onlyOwner {
        // the price feed updates every 24hr, so change it to 72k later
        interval = newInterval;
    }

    /*
    * The following functions are overrides required by Solidity.
    */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}