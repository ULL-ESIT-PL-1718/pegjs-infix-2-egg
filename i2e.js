#!/usr/bin/env node 
const fs = require("fs");
let insp = require("util").inspect;
let ins = (x) => insp(x, {depth:null});
const PEG = require("./infix2egg.js");
let version = require('package.json').version;

let program = require('commander');
 


program
  .version(version)
  .usage('[options] <programPath>')
  .option('-t, --tree', 'Show AST')
  .option('-o, --output [file]', 'Output file')
  .parse(process.argv);

try {
  if (!program.args.length) program.help();

  let fileName = program.args.shift();

  let infixProgram = fs.readFileSync(fileName, 'utf8');
  let tree = PEG.parse(infixProgram);
  let json = JSON.stringify(tree, null, "  ");
  if (program.tree) console.log(`program: ${infixProgram}\nresult = ${json}`);
  let outputFile = (program.output && program.output) || fileName+".evm";
  fs.writeFileSync(outputFile, json);
}
catch (err) {
  console.log(err);
  console.log(`${err.message} at line ${err.location.start.line} column ${err.location.start.column} offset ${err.location.start.offset}`);
}


