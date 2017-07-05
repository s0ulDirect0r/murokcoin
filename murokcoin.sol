/* This line specifies which version of the solidity compiler should be used */
/* a pragma in CS tells how a compiler should process it's input */
/* more details: pragmas are a form of directive, like #define in C */
pragma solidity ^0.4.8;

contract owned {
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  modifier onlyOwner {
    if (msg.sender != owner) throw;
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }
}

contract MurokCoin is owned {
  /* An event allows us to use the EVM logging systems to store arguments in the transaction's logs
  */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /* Public variables of the token */
  string public name;
  string public symbol;
  uint8 public decimals;

  /* Creating an array with all balances, all of which are publicly accessible on the blockchain */
  /* matt note: this is basically a hash table, or like a key-value object in JS */
  /* the key is address, the value is an integer representing a balance */
  mapping (address => uint256) public balanceOf;

  function MurokCoin(
    uint256 initialSupply,
    string tokenName,
    string tokenSymbol,
    uint8 decimalUnits,
    address centralMinter
    ) {
  /* this function runs once when a contract is uploaded to the network */
    if(centralMinter != 0 ) owner = centralMinter;
    balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
    name = tokenName; // Set the name for display purposes
    symbol = tokenSymbol; // Set the symbol for display purposes
    decimals = decimalUnits; // Amount of decimals for display purposes
  }

  /* Send coins */
  function transfer(address _to, uint256 _value) {
    /* Check if sender has balance and for overflows */
    if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to] )
      throw;
    /* Add and subtract new balances */
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    /* Notify anyone listening that this transfer took place */
    Transfer(msg.sender, _to, _value);
  }
}
