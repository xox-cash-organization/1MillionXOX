pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/token/ERC20/ERC20.sol";

contract OneMillionXOX is ERC20 {
  constructor() ERC20("1MillionXOX", "XoX") {
    _mint(msg.sender, 1000000);
  }
}