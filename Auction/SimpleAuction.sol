// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

abstract contract Pausable {

    bool internal _paused;

    error PAUSED();
    error UNPAUSED();

    modifier whenPaused() {
        if (!_paused) revert UNPAUSED();
        _;
    }

    modifier whenNotPaused() {
        if (_paused) revert PAUSED();
        _;
    }

    constructor() {
        _paused = true;
    }

    function paused() external view returns (bool) {
        return _paused;
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
    }
}

contract SimpleAuction is Pausable {

    struct Auction {
        uint256 tokenId;
        uint256 highestBid;
        address highestBidder;
        uint40 startTime;
        uint40 endTime;
        bool settled;
    }

    Auction public auction;

    Token public token;

    error INVALID_TOKEN_ID();
    error AUCTION_OVER();

    constructor() {
        token = new Token();
    }

    function createBid(uint256 _tokenId) external payable {
        // Get a copy of the current auction
        Auction memory _auction = auction;

        // Ensure the bid is for the current token
        if (_auction.tokenId != _tokenId) revert INVALID_TOKEN_ID();

        // Ensure the auction is still active
        if (block.timestamp >= _auction.endTime) revert AUCTION_OVER();

        require(msg.value > auction.highestBid);

        // Store the new highest bid
        auction.highestBid = msg.value;

        // Store the new highest bidder
        auction.highestBidder = msg.sender;
    }

    /// @dev Creates an auction for the next token
    function _createAuction() private {
        // Get the next token available for bidding
        try token.mint() returns (uint256 tokenId) {
            // Store the token id
            auction.tokenId = tokenId;

            // Cache the current timestamp
            uint256 startTime = block.timestamp;

            // Used to store the auction end time
            uint256 endTime;

            // Cannot realistically overflow
        unchecked {
            // Compute the auction end time
            endTime = startTime + 1 days;
        }

            // Store the auction start and end time
            auction.startTime = uint40(startTime);
            auction.endTime = uint40(endTime);

            // Reset data from the previous auction
            auction.highestBid = 0;
            auction.highestBidder = address(0);
            auction.settled = false;

            // Pause the contract if token minting failed
        } catch Error(string memory) {
            _pause();
        }
    }

    function unpause() external {
        _unpause();

        // If this is the first auction:
        if (auction.tokenId == 0 && auction.startTime == 0) {
            // Start the first auction
            _createAuction();
        }
    }

    function pause() external {
        _pause();
    }
}

contract Token {
    uint totalSupply;

    function mint() external returns (uint256 tokenId) {
        tokenId = totalSupply++;
    }
}
