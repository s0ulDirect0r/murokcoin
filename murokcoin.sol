/* This line specifies which version of the solidity compiler should be used */
/* a pragma in CS tells how a compiler should process it's input */
/* more details: pragmas are a form of directive, like #define in C */
pragma solidity ^0.4.8;

contract owned {
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  /* checks if modified function is being sent run by owner */
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
  bytes32 public currentChallenge; // The coin starts with a challenge
  uint public timeOfLastProof; // Variable to keep track of when rewards were given
  uint public difficulty = 10**32; // Difficulty starts reasonably low

  /* Creating an array with all balances, all of which are publicly accessible on the blockchain */
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
    timeOfLastProof = now;
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

  /* Reward ether miners with MurokCoins */
  function giveBlockReward() {
      balanceOf[block.coinbase] += 1;
  }

  function proofOfWork(uint nonce) {
      bytes8 n = bytes8(sha3(nonce, currentChallenge)); // Generate a random hash based on input
      if (n < bytes8(difficulty)) throw;

      uint timeSinceLastProof = (now - timeOfLastProof); // Calculate time since last reward was given
      if (timeSinceLastProof < 5 seconds) throw; // Rewards cannot be given too quickly
      balanceOf[msg.sender] += timeSinceLastProof / 60 seconds; // The reward to the winner grows by the minute

      difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; // Adjusts the difficulty

      timeOfLastProof = now;
      currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1)); // save a hash that will be used as the next proof
  }
}
