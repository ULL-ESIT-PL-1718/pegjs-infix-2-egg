Example using PEG.js. 

Translates infix expressions to Egg Virtual Machine (evm.js)

```
$ pegjs infix2egg.pegjs
$ cat examples/minus.inf
2*4*2-3-5*2
$ ./i2e.js examples/minus.inf
program: 2*4*2-3-5*2

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
                  "args": [
                    {
                      "type": "value",
                      "value": 2
                    },
                    {
                      "type": "value",
                      "value": 4
                    }
                  ]
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
          "args": [
            {
              "type": "value",
              "value": 5
            },
            {
              "type": "value",
              "value": 2
            }
          ]
        }
      ]
    }
  ]
}
$ ls -ltr examples/
total 16
-rw-r--r--  1 casiano  staff    12 22 abr 15:09 minus.inf
-rw-r--r--  1 casiano  staff  2498 22 abr 16:11 minus.inf.evm
$ crguezl-egg/bin/evm.js examples/minus.inf.evm 
3
```

It uses the definitions in `lib/ast.js`. Be sure you have access to it
