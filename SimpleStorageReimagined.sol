pragma solidity ^0.4.24;

contract SimpleStorageReimagined {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() constant public returns (uint) {
        return storedData;
    }

    function increment(uint n) public {
        storedData = storedData + n;
    }

    function decrement(uint n) public {
        storedData = storedData - n;
    }
}
