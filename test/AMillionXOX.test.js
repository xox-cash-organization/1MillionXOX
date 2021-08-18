const BigNumber = web3.BigNumber;
const OneMillionXOX = artifacts.require("./AMillionXOX.sol");

require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(BigNumber))
  .should();

contract("1MillionXOX", (accounts) => {
  let tokenContract;

  before(async () => {
    tokenContract = await OneMillionXOX.deployed();
  });

  it("should retrieve correct balance", async () => {
    const balance = await tokenContract.balanceOf.call(accounts[0]);
    balance.toString().should.be.bignumber.equal(1e24);
  });

  it("should be able to transfer exact amount", async () => {
    const amount = 10e3;
    await tokenContract.transfer(accounts[1], amount, { from: accounts[0] });
    const balance = await tokenContract.balanceOf.call(accounts[1]);
    assert.equal(balance.valueOf(), amount);
  });
});
