// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Migrations contract is used to track the deployment of the smart contract
// and to update the state of the smart contract
contract Migrations {
    address public owner;
    uint256 public last_completed_migration;

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
