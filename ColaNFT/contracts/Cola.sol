pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import 'hardhat/console.sol';

contract ColaNFT is ERC721URIStorage  {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor () ERC721('ColaNFT', "Gaurav's Cola"){}

    function mintNFT()
        public
        returns (uint256)
        {
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _mint(msg.sender, newItemId);
            _setTokenURI(newItemId, "https://jsonkeeper.com/b/YZBQ");
            console.log("The NFT ID %s has been minted to %s", newItemId, msg.sender);
           return newItemId;
        }
}