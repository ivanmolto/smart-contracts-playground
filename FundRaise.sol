pragma solidity ^0.4.24;

contract FundRaise {

    address public owner;
    bool paused;

    // modifiers
    modifer onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    // @dev constructor function. Sets contract owner

    constructor() public {
        owner = msg.sender;
    }

    function() whenNotPaused payable {

    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    function removeFunds() public {
        owner.transfer(this.balance);
    }

}
