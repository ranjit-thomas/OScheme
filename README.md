
<h3>Not Yet Implemented (Be sure to update above trees when I do):</h3>

- ERROR HANDELING!!!!!
- Not really sure if t ype checking is happening or where its supposed to happen.
- Defining a function *without* using "lambda". 
- Negative Numbers
- Record
- Booleans
- SemiColons
- Strings
- Symbols that are expanded to include non-alphabetic characters
- Migrate this entire file to another file with another name, and make this actual "README".

<h1>Lexical Analysis of Scheme (AST used by interpereter)</h1>

S-Program := S-Expression

S-Expression := S-Symbol | S-List | S-Value | S-Definition | S-Conditional | S-Func-Call | S-Anonym-Func

S-List := ( [S-Expression]* )

S-Symbol := string

*more S-Value's to come...*

S-Value := int

S-Definition := ( define S-Symbol *Def-Expr* )

S-Conditional := ( if *Cond-Condition* *Cond-If* *Cond-Else* )

S-Func-Call := ( *Func-Name* [*Func-Arg*]* )

**Note:** All italicized tokens above evaluate to **S-Expressions**.

<h3> List of Terminals </h3>

**Note:** These are what the Lexer needs to be parsing for.

- (
- )
- "if"
- "define"
- "quote"
- "lambda"
- string
- int

<h1>DesignPlan</h1>

<h3>Prologue: Setting Up User-Interaction</h3>

1. Set up a main function that looks exclusively for one or zero arguments.
2. Set up a function to call when in interactive mode.
3. Set up a function to call when in input-file mode.
4. Set up a generic, "run" function.

<h2>The Front End</h2>

<h3>The Lexer</h3>

1. Define tokens in a file titled "token.ml".  Should include tokens for:
	1. identifiers
	2. literals
	3. operators
	4. delimeters
2. Initialize a "convert_to_string" function that converts the tokens to 
	string (for testing purposes). 
3. Write a general, process_tokens function that iterates over the input and generates 
	new tokens from the strings in input file.
4. Cover all cases for non-literals.
5. Cover cases for literals (symbols and numbers).

<h3>The Parser</h3>

1. Initialize an enum for each piece of grammar in Scheme (see above lexical analysis of scheme).
2. Write a "tokens_to_s-expr" function.  Should include following cases:
	1. Any element of the AST
	2. Early EOF --> an error.
	3. Unmatched closing paranthese --> an error.
	4. Open paranthesis --> a list of S-Expresions that need to be recursed on.
<h3>The Evaluater</h3>

**Note:** This is where we'll create an "env" where we'll finaly be able to include some unary and binary operators (see "Environemnts" section of https://norvig.com/lispy.html)

<h2>The Back End</h2>

<h3>Creating the Byte code</h3>

<h3>Creating the Native Code (via a mini-compiler)</h3>

<h3>Runtime Responsabilities</h3>

**Note:** Still not really sure what these are... peep section 2.1.8 of https://craftinginterpreters.com/a-map-of-the-territory.html


