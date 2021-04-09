const express = require("express");

const app = express();

app.get("/code", (req, res) => {
  res.send({ number: 321.213 });
});

port = 3000;

app.listen(port, () => {
  console.log(`Server started at http://localhost:${port}`);
});