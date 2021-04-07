const Oracle = artifacts.require("Oracle");
const ATestnetConsumer = artifacts.require("ATestnetConsumer");
require("dotenv").config();

module.exports = async function (callback) {
  const con = await ATestnetConsumer.deployed();
  tx = await con.requestEthereumPrice(
    (await Oracle.deployed()).address,
    process.env.JOB_ID
  );

  console.log(tx);

  callback("\nFinished.");
};
