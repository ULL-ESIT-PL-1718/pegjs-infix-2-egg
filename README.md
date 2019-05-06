Example using PEG.js. 

Translates infix expressions to Egg Virtual Machine ([evm.js](https://github.com/ULL-ESIT-PL-1718/egg/blob/private/bin/evm.js) *private link*)

* You have to make a Simbolic Link to the directory containing the sources of Egg: 
  - crguezl-egg -> /Users/casiano/local/src/javascript/PLgrado/eloquentjsegg
  - See file infix2egg.pegjs: const {Value, Word, Apply} = require("crguezl-egg/lib/ast.js")

* Compile the grammar:
```
$ pegjs infix2egg.pegjs
```
* Now consider this infix *program*:
E```
$ cat examples/minus.inf
2*4*2-3-5*2
```
* Run the translator `i2e`:
```
$ ./i2e.js examples/minus.inf
program: 2*4*2-3-5*2
```
* It outputs the following AST:
```javascript
result = {
  "type": "apply",
  "operator": {
    "type": "word",
    "name": "print",
  },
  "args": [
    {
      "type": "apply",
      "operator": {
        "type": "word",
        "name": "-",
      },
      "args": [
        {
          "type": "apply",
          "operator": {
            "type": "word",
            "name": "-",
          },
          "args": [
            {
              "type": "apply",
              "operator": {
                "type": "word",
                "name": "*",
              },
              "args": [
                {
                  "type": "apply",
                  "operator": {
                    "type": "word",
                    "name": "*",
                  },
                  "args": [ { "type": "value", "value": 2 }, { "type": "value", "value": 4 } ]
                },
                {
                  "type": "value",
                  "value": 2
                }
              ]
            },
            {
              "type": "value",
              "value": 3
            }
          ]
        },
        {
          "type": "apply",
          "operator": {
            "type": "word",
            "name": "*",
          },
          "args": [ { "type": "value", "value": 5 }, { "type": "value", "value": 2 } ]
        }
      ]
    }
  ]
}
```
* The result of the compilation is a JSON file `minus.inf.evm`:`
```
$ ls -ltr examples/
total 16
-rw-r--r--  1 casiano  staff    12 22 abr 15:09 minus.inf
-rw-r--r--  1 casiano  staff  2498 22 abr 16:11 minus.inf.evm
```
* Now we can execute the `.evm` file using our `evm` virtual machine/interpreter:
```
$ crguezl-egg/bin/evm.js examples/minus.inf.evm 
3
```
* To make this program works, the PEG file makes use of the definitions in  our 
library `lib/ast.js`:

```javascript
{ 
  const {Value, Word, Apply} = require("crguezl-egg/lib/ast.js")
  ...
}
...
```

* Be sure you have access to your version of the lib!

* Since JSON dos not gives support to objects we have to modify the file [`lib/eggvm.js`](https://github.com/ULL-ESIT-PL-1718/egg/blob/private/lib/eggvm.js#L31-L65) (*private link*) 
to re-build the objects from the JSON flat hashes (remember we decided to represent 
our virtual machine programs in JSON format).
To achieve this goal we introduce 
the `json2AST`method:

```javascript
function json2AST(flatObject) {
  switch(flatObject.type) {
    case 'value':
      return new Value(flatObject);

    case 'word':
      return new Word(flatObject);

    case 'apply':
      let obj = new Apply({
        type: "apply", 
        args: [], 
        operator: json2AST(flatObject.operator)
      });
      obj.args = flatObject.args.map(json2AST);
      return obj;
    default: throw "Strange AST tree!!!"
  }
}
```

Therefore, after reading the JSON file, we parse it with `JSON.parse` and 
rebuild the AST objects with `json2AST`:

```javascript
function runFromEVM(fileName) {
  try {
    let json = fs.readFileSync(fileName, 'utf8');
    let treeFlat = JSON.parse(json);
    let tree = json2AST(treeFlat);
    let env = Object.create(topEnv);
    return tree.evaluate(env);
  }
  catch (err) {
    console.log(err);
  }
}
```
