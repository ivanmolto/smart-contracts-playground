pragma solidity ^0.4.22;

contract SimpleAuction {

    address public beneficiary;
    uint public auctionEnd;

    // Current state of the auction
    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping (address => uint) pendingReturns;

    // Set to true at the end, disallows any change
    bool ended;

    // Events that will be fired on changes
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    /// Create a simple auction with '_biddingTime'
    /// seconds bidding time on behalf of the
    /// beneficiary address '_beneficiary'

    constructor(uint _biddingTime, address _beneficiary) public {
        beneficiary = _beneficiary;
        auctionEnd = now + _biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won
    function bid() public payable {
        // No arguments are necessary, all information
        // is already part of the transaction.

        // Revert the call if the bidding
        // period is over
        require(now <= auctionEnd, "Auction already ended.");

        // If the bid is not higher, send th
        // money back.

        require(msg.value > highestBid, "There already is a higher bid.");

        if (highestBid != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        i (amount > 0) {

    }
    }

    /// End the auction and send the highest bid
    /// to the beneficiary
    function auctionEnd() public {
        // 1. Checking conditions
        require(now >= auctionEnd, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. Actions
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}
