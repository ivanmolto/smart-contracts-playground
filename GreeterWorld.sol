pragma solidity ^0.4.24;

contract GreeterWorld {
    string public yourName;

    constructor() public {
        yourName = "World";
    }

    function set(string name) public {
        yourName = name;
    }

    function hello() constant public returns (string) {
        return yourName;
    }
}
