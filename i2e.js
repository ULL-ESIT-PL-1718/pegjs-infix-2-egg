#!/usr/bin/env node 
const fs = require("fs");
let insp = require("util").inspect;
let ins = (x) => insp(x, {depth:null});
const spawn = require('child_process').spawn;
const PEG = require("./infix2egg.js");
let package = require('package.json');
let version = package.version;
let description = package.description;
let evm = package.evm;

let commander = require('commander');
 


commander
  .version(version)
  .description(description)
  .usage('[options] <programPath>')
  .option('-t, --tree', 'Show AST')
  .option('-o, --output [file]', 'Output file')
  .option('-r, --run', 'Run program')
  .parse(process.argv);

try {
  if (!commander.args.length) commander.help();

  let fileName = commander.args.shift();

  let infixProgram = fs.readFileSync(fileName, 'utf8');
  let tree = PEG.parse(infixProgram);
  let json = JSON.stringify(tree, null, "  ");
  if (commander.tree) console.log(`program: ${infixProgram}\nresult = ${json}`);
  let outputFile = (commander.output && commander.output) || fileName+".evm";
  fs.writeFileSync(outputFile, json);
  if (commander.run) {
    const evmRun = spawn(evm, [ outputFile ]);
    evmRun.stdout.pipe(process.stdout);
  }
}
catch (err) {
  if (err.message && err.location)
    console.log(`${err.message} at line ${err.location.start.line} column ${err.location.start.column} offset ${err.location.start.offset}`);
  else console.log(err);
  commander.help();
}


