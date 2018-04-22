#!/usr/bin/env node 
var input = process.argv[2] || "2-3-4";
var PEG = require("./infix2egg.js");
var r = PEG.parse(input);
console.log(`input: ${input}\nresult = ${r}`);

