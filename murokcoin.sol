/* This line specifies which version of the solidity compiler should be used */
/* a pragma in CS tells how a compiler should process it's input */
/* more details: pragmas are a form of directive, like #define in C */
pragma solidity ^0.4.8;

contract MurokCoin {
  /* Creating an array with all balances, all of which are publicly accessible on the blockchain */
  /* matt note: this is basically a hash table, or like a key-value object in JS */
  /* the key is address, the value is an integer representing a balance */
  mapping (address => uint256) public balanceOf;

  function MurokCoin(uint256 initialSupply) {
  /* this function runs once when a contract is uploaded to the network */
    balanceOf[msg.sender] = initialSupply;
  }

  /* Send coins */
  function transfer(address _to, uint256 _value) {
    /* Check if sender has balance and for overflows */
    if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to] )
      throw;
    /* Add and subtract new balances */
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
  }
}
