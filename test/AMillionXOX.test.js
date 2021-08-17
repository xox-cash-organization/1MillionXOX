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
    balance.toString().should.be.bignumber.equal(6e23);
  });

  it("should retrieve correct total locked amount", async () => {
    const locked = await tokenContract.totalLocked();
    locked.toString().should.be.bignumber.equal(4e23);
  });

  it("should be able to transfer exact amount", async () => {
    const amount = 10e3;
    await tokenContract.transfer(accounts[1], amount, { from: accounts[0] });
    const balance = await tokenContract.balanceOf.call(accounts[1]);
    assert.equal(balance.valueOf(), amount);
  });

  it("only contract creator can lock tokens", async () => {
    const toLock = 2000;
    tokenContract
      .lock(toLock, { from: accounts[1] })
      .should.be.rejectedWith(
        "Only contract creator can execute this operation"
      );

    await tokenContract.lock(toLock, { from: accounts[0] });
    const totalLocked = await tokenContract.totalLocked();
    const balance = await tokenContract.balanceOf.call(accounts[0]);
    const totalSupply = totalLocked.add(balance);
    assert.equal(totalSupply.valueOf(), 1e24);
  });
});
