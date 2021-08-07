const OneMillionXOX = artifacts.require("./1MillionXOX.sol");

module.exports = function (deployer) {
  deployer.deployer(OneMillionXOX);
};
