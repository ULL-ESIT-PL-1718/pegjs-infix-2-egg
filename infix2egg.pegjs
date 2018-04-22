{ 
  function reduce(left, right) {
    return right.reduce((sum, [op, num]) => eval(`sum ${op}= num`), left);
  }
}

expression = sum:sum EOI                         { return sum; }
sum        = left:product right:($plus product)* { return reduce(left, right); }
product    = left:value   right:($mult value)*   { return reduce(left, right); }
value      = number:number                       { return number; }
           / LP sum:sum RP                       { return sum; }

/* Lexical Analysis Section */
plus   = __ plus:$[+-]      { return plus; }
mult   = __ mult:$[*/]      { return mult; }
number = __ number:$[0-9]+  { return parseInt(number,10); }
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


