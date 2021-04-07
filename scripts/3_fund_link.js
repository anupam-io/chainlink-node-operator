const Oracle = artifacts.require("Oracle");
const ATestnetConsumer = artifacts.require("ATestnetConsumer");
const Link = require("@chainlink/contracts/abi/v0.6/LinkTokenInterface.json");
require("dotenv").config();

module.exports = async function (callback) {
  const link = new web3.eth.Contract(
    Link.compilerOutput.abi,
    process.env.LINK_CONTRACT_ADDRESS
  );

  const acc = await web3.eth.getAccounts();

  const amount = (10 ** 2).toString();
  tx = await link.methods
    .transfer((await Oracle.deployed()).address, amount)
    .send({ from: acc[0] });
  console.log(tx.gasUsed);

  tx = await link.methods
    .transfer((await ATestnetConsumer.deployed()).address, amount)
    .send({ from: acc[0] });
  console.log(tx.gasUsed);

  callback("\nFinished.");
};
