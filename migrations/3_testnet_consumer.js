const APIConsumer = artifacts.require("APIConsumer");

module.exports = function (deployer) {
  deployer.deploy(APIConsumer);
};