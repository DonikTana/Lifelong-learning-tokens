// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LifelongLearningToken {
    // State variables
    string public name = "Lifelong Learning Token";
    string public symbol = "LLT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // Mapping to track the balance of each address
    mapping(address => uint256) public balanceOf;

    // Mapping to track the allowance that one address has given another
    mapping(address => mapping(address => uint256)) public allowance;

    // Events for Transfer and Approval
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor to initialize total supply to the contract deployer
    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    // Function to transfer tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Function to approve another address to spend tokens on behalf of the message sender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Function to transfer tokens on behalf of another address, using the allowance mechanism
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Function to mint new tokens
    function mint(address _to, uint256 _value) public returns (bool success) {
        totalSupply += _value * 10 ** uint256(decimals);
        balanceOf[_to] += _value * 10 ** uint256(decimals);
        emit Transfer(address(0), _to, _value);
        return true;
    }

    // Function to burn tokens
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
        balanceOf[msg.sender] -= _value * 10 ** uint256(decimals);
        totalSupply -= _value * 10 ** uint256(decimals);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }
}
