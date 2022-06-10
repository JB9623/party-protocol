// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "forge-std/Test.sol";

import "../../contracts/proposals/zora/IZoraAuctionHouse.sol";

contract ZoraTestUtils is Test {
    IZoraAuctionHouse private immutable _ZORA;

    constructor(IZoraAuctionHouse zora) {
        _ZORA = zora;
    }

    function _bidOnZoraListing(uint256 auctionId, address bidder, uint256 bidPrice)
        internal
    {
        hoax(bidder, bidPrice);
        _ZORA.createBid{ value: bidPrice }(auctionId, bidPrice);
    }
}
