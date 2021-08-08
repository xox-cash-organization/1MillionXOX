const OneMillionXOX = artifacts.require("./OneMillionXOX.sol");

module.exports = function (deployer) {
  deployer.deployer(OneMillionXOX);
};
