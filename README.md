
<h3>Not Yet Implemented (Be sure to update above trees when I do):</h3>

- More specific error messages.
- Refer to https://github.com/cwfoo/ocaml-scheme-interpreter to see how to use "make test" and "make (a single executable)".
- I think my token and s-expression classes are structs within a struct... see if i can change that.
- Need to make Token and SExpression class private (right now all fields can be easily accessed and modifified).
- Running empty scheme programs.
- S-Expressions need to be pointers.
- Lists
- Defining a function *without* using "lambda". 
- Negative Numbers
- Record
- SemiColons
- Strings
- Symbols that are expanded to include non-alphabetic characters
- Migrate this entire file to another file with another name, and make this actual "README".
- Create a script that runs all the other testing scripts.
- Consider removing the "token_literal_type" filed of token and somehow directly incorporating the literals into "token_type"
- There's a lot of lack of coverage in unit tests... that needs to be fixed one day.

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

<h2>The Front End</h2>

<h3>Setting Up User-Interaction</h3>

1. Set up a main function that looks exclusively for one or zero arguments.
2. Set up a function to call when in interactive mode.
3. Set up a function to call when in input-file mode.
4. Set up a generic, "run" function.

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

<h2>The Back End</h2>

<h3>The Parser</h3>

1. Initialize an enum for each piece of grammar in Scheme (see above lexical analysis of scheme).
2. Write a "tokens_to_s-expr" function.  Should include following cases:
	1. Any element of the AST
	2. Early EOF --> an error.
	3. Unmatched closing paranthese --> an error.
	4. Open paranthesis --> a list of S-Expresions that need to be recursed on.
3. Write a file to test each case.

<h3>The Env: An Internal Module Used by Evaluater</h3>

1. Create a type that is an OCaml Dictionary that maps SExpression symbols to any SExpression
2. Create a constructor that returns a default global environment that's loaded with some default operators like '+', '-', 'not'.  Once I have these working, look to [here](https://courses.cs.washington.edu/courses/cse341/03wi/scheme/basics.html) for more examples of primitive types.
3. Create a constructor that returns a default local environment thats loaded with parameters that are passed in.
4. Create a method that combines global and local environment and returns a new, global env.
5. Create a __lookup__ method that searches a local env, and another one that searches a global env.
6. Create a __bind__ method that adds to a local env and returns a new, local env.  This might be more complex then I think.

<h3>The Evaluater</h3>

1. Create a couple of helper functions that can:
	- Determine the type of a value
	- Determine whether a value is "truthy".
	- Tell if two objects are equal.
2. Consider creating a superclass for all values or all objects.
3. 


**Note:** This is where we'll create an "env" where we'll finaly be able to include some unary and binary operators (see "Environemnts" section of https://norvig.com/lispy.html)


