const { default: axios } = require("axios");

async function main() {
  url = `http://localhost:3000/code`;
  res = await axios.get(url);
  console.log(res.data.number);
}
main();
