#!/usr/bin/env node 
const fs = require("fs");
let insp = require("util").inspect;
let ins = (x) => insp(x, {depth:null});
const PEG = require("./infix2egg.js");
try {
  let fileName = process.argv[2];
  let program = fs.readFileSync(fileName, 'utf8');
  let tree = PEG.parse(program);
  let json = JSON.stringify(tree, null, "  ");
  console.log(`program: ${program}\nresult = ${json}`);
  fs.writeFileSync(fileName+".evm", json);
}
catch (err) {
  console.log(err);
}

