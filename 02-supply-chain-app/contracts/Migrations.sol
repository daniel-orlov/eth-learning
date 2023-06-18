// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Migrations contract is used to track the deployment of the smart contract
// and to update the state of the smart contract
contract Migrations {
    address public owner;
    uint256 public lastCompletedMigration;

    modifier restricted() {
        require (msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCompleted(uint256 completed) public restricted {
        lastCompletedMigration = completed;
    }

    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(lastCompletedMigration);
    }
}
