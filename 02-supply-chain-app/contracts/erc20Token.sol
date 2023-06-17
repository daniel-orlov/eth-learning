// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./erc20Interface.sol";

contract erc20Token is erc20Interface {
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    uint256 public totalSupply; // total supply of the token
    string public name; // name of the token
    uint8 public decimals; // how many decimals to show on token
    string public symbol; // symbol of token, like ETH, DAI, etc...

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount; // Give the creator all initial tokens
        totalSupply = _initialAmount; // Update total supply
        name = _tokenName; // Set the name for display purposes
        decimals = _decimalUnits; // Amount of decimals for display purposes
        symbol = _tokenSymbol; // Set the symbol for display purposes
    }

    // transfer token from msg.sender to a specified address
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        require(
            balances[msg.sender] >= _value,
            "You do not have enough tokens to transfer"
        ); // Check if the sender has enough
        balances[msg.sender] -= _value; // Subtract from the sender
        balances[_to] += _value; // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
        return true;
    }

    // transfer token from a specified address to another specified address
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(
            balances[_from] >= _value && allowance >= _value,
            "You do not have enough tokens to transfer"
        ); // Check if the sender has enough
        balances[_to] += _value; // Add the same to the recipient
        balances[_from] -= _value; // Subtract from the sender
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); // Notify anyone listening that this transfer took place
        return true;
    }

    // return the balance of a specified address
    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[_owner];
    }

    // approve a specified address to spend a specified amount of tokens on behalf of msg.sender
    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(
            msg.sender,
            _spender,
            _value
        ); // Notify anyone listening that this approval took place
        return true;
    }

    // allowance of a specified address to spend a specified amount of tokens on behalf of msg.sender
    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    function totalSupply() public view override returns (uint256 supply) {
        return totalSupply;
    }
}
