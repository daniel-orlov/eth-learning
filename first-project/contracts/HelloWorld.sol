// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld {
    string public message;

    constructor() public {
        message = "Hello World";
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function update(string memory _message) public {
        message = _message;
    }
}
