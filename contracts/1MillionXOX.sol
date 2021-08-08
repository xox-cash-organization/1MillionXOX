pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract OneMillionXOX is ERC20 {
  uint public INITIAL_SUPPLY = 1000000;

  mapping(address => uint) private balances;
  mapping(address => mapping(address => uint)) private allowed;

  constructor() public ERC20("1MillionXOX", "XOX") {
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
  }

  function decimals() public view virtual override returns (uint8) {
    return 18;
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