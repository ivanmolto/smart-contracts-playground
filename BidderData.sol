pragma solidity ^0.4.24;

contract BidderData {

    string public name;
    uint public bidAmount = 20000;
    bool public  eligible;
    uint constant minBid = 1000;


}
