{ 
  const {Value, Word, Apply} = require("crguezl-egg/lib/ast.js")

/*
> -(2, -(3,4))
Apply {
  type: 'apply',
  operator: 
   Word {
     type: 'word',
     name: '-',
      },
  args: 
   [ Value { type: 'value', value: 2 },
     Apply {
       type: 'apply',
       operator: 
        Word {
          type: 'word',
          name: '-',
           },
       args: 
        [ Value { type: 'value', value: 3 },
          Value { type: 'value', value: 4 } ] } ] }
*/
  function reduce(left, right) {
    return right.reduce(
      (sum, [op, num]) => {
                             debugger;
                             return new Apply({
                                 type: 'apply',
                                 operator: op,
                                 args: [sum, num]
                             });  // end Apply
                          },
      left // 2nd argument for reduce. Initial value 
    ); // end reduce
  }
}

print      = e:expression                        
  {
     return new Apply({
				type: 'apply',
				operator: 
				  new Word({
					 type: 'word',
					 name: 'print',
					 token: { type: 'WORD', value: 'print', lineno: 1, offset: 0 } }),
					args: [e] });
  }
expression = sum:sum EOI                         { return sum; }
sum        = left:product right:(plus product)*  { return reduce(left, right); }
product    = left:value   right:(mult value)*    { return reduce(left, right); }
value      = number:number                       { return number; }
           / LP sum:sum RP                       { return sum; }

/* Lexical Analysis Section */
plus   = __ plus:$[+-]
  { 
    // debugger;
    return new Word({ 
      type: 'word', 
      name: plus, 
      token: { type: 'WORD', value: plus, lineno: 1, offset: 0 } 
    });
  }
mult   = __ mult:$[*/]      
  { 
    //debugger;
    return new Word({
      type: 'word',
      name: mult,
      token: { type: 'WORD', value: mult, lineno: 1, offset: 0 } 
    });
  }

number = __ number:$[0-9]+  
  { 
      return new Value({ type: 'value', value: parseInt(number,10) });
  }

LP     = __ '('
RP     = __ ')'
EOI    = __ !.

__ = (whitespace / eol / comment)*

/* Modeled after ECMA-262, 5th ed., 7.4. */
comment "comment"
  = singleLineComment
  / multiLineComment

singleLineComment
  = "//" (!eolChar .)*

multiLineComment
  = "/*" (!"*/" .)* "*/"


/* Modeled after ECMA-262, 5th ed., 7.3. */
eol "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

eolChar
  = [\n\r\u2028\u2029]

whitespace "whitespace"
  = [ \t\v\f\u00A0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]


