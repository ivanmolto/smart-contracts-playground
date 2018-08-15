pragma solidity ^0.4.24;

contract Namespace {

    struct NameEntry {
        address owner;
        bytes32 value;
    }

    uint32 constant REGISTRATION_COST = 100;
    uint32 constant UPDATE_COST = 10;

    mapping (bytes32 => NameEntry) data;

    function nameNew(bytes32 hash) {
        if (msg.value >= REGISTRATION_COST) {
            data[hash].owner = msg.sender;
        }
    }

    function nameUpdate(bytes32 name, bytes32 newValue, address newOwner) {
        bytes32 hash = sha3(name);
        if (data[hash].owner == msg.sender && msg.value >= UPDATE_COST) {
            data[hash].vaue = newValue;
            if (newOwner != 0) {
                data[hash].owner = newOwner;
            }
        }
    }

    function nameLookup(bytes32 name) {
        return data[sha3(name)];
    }
}
