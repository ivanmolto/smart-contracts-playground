pragma solidity ^0.4.24;

contract GreeterBytes {
    bytes32 public yourName;

    constructor() public {
        yourName = "World";
    }

    function set(bytes32 name) public {
        yourName = name;
    }

    function hello() constant public returns (bytes32) {
        return yourName;
    }
}
