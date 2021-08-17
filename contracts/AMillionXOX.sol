pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AMillionXOX is ERC20 {
  uint public INITIAL_SUPPLY = 1000000 * 10 ** 18;
  address private contractCreator;
  uint private locked = 0;

  modifier onlyCreator {
    require(msg.sender == contractCreator, "Only contract creator can execute this operation");
    _;
  }

  mapping(address => uint) private balances;
  mapping(address => mapping(address => uint)) private allowed;

  constructor() public ERC20("One Million XOX", "XOX") {
    contractCreator = msg.sender;
    lock(400000 * 10 ** 18);
    balances[contractCreator] = INITIAL_SUPPLY - locked;

    emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
  }

  function lock(uint amount) public onlyCreator returns (bool) {
    
    if (locked == 0) {
      require(INITIAL_SUPPLY > amount, "Cannot lock all token");
    }
    if (locked > 0) {
      require(SafeMath.add(locked, amount) < totalSupply(), "Amount to be locked + currently locked must be less than total supply");
    }
    if (balances[contractCreator] > 0) {
      require(balances[contractCreator] > amount, "Amount to be locked must be less than balance of contract creator");
      balances[contractCreator] = SafeMath.sub(balances[contractCreator], amount);
    }

    locked = SafeMath.add(locked, amount);
    return true;
  }

  function unlock(uint amount) public onlyCreator returns (bool) {
    require(locked >= amount, "Currently locked amount must be greater than or equal to amount to be unlocked");
    locked = SafeMath.sub(locked, amount);
    balances[contractCreator] = SafeMath.add(balances[contractCreator], amount);
    return true;
  }

  function decimals() public view virtual override returns (uint8) {
    return 18;
  }

  function totalLocked() public view returns (uint) {
    return locked;
  }

  function totalSupply() public view virtual override returns (uint) {
    return INITIAL_SUPPLY - balances[address(0)];
  }

  function balanceOf(address owner) public view virtual override returns (uint256) {
    return balances[owner];
  }

  function allowance(address owner, address spender) public view virtual override returns (uint remaining) {
    return allowed[owner][spender];
  }

  function approve(address spender, uint spendable) public override returns (bool success) {
    allowed[msg.sender][spender] = spendable;
    emit Approval(msg.sender, spender, spendable);
    return true;
  }

  function transfer(address to, uint amount) public virtual override returns (bool transferred) {
    return transferFrom(msg.sender, to, amount);
  }

  function transferFrom(address from, address to, uint amount) public override returns (bool) {
    if (from != msg.sender && allowed[from][msg.sender] > uint(int(-1))) {
      require(allowed[from][msg.sender] >= amount, "No approval given");
      allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender], amount);
    }
    require(balances[from] >= amount, "Not enough balance");
    balances[from] = SafeMath.sub(balances[from], amount);
    balances[to] = SafeMath.add(balances[to], amount);
    emit Transfer(from, to, amount);
    return true;
  }
}