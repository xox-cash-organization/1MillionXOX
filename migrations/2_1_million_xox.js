const OneMillionXOX = artifacts.require("./AMillionXOX.sol");

module.exports = function (deployer) {
  deployer.deploy(OneMillionXOX);
};
