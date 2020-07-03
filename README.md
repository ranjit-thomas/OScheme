
<h3>Not Yet Implemented (Be sure to update above trees when I do):</h3>

- ERROR HANDELING!!!!!
- Negative Numbers
- Record
- Booleans
- SemiColons
- Strings
- Quote (super important)
- Symbols that are expanded to include non-alphabetic characters
- Migrate this entire file to another file with another name, and make this actual "README".

<h1>Lexical Analysis of Scheme</h1>

S-Program := S-Expression

S-Expression := S-Symbol | ( [S-Expression]* ) | S-Value | S-Definition | S-Conditional | S-Func-Call

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
- string
- int

<h1>DesignPlan</h1>

<h2>The Front End</h2>

<h3>Setting Up UserInteraction</h3>
1. Set up a main function that looks exclusively for one or zero arguments.
2. Set up a function to call when in interactive mode.
3. Set up a function to call when in input-file mode.
4. Set up a generic, "run" function.

<h3>The Lexer</h3>
1. Define tokens in a file titled "token.ml".  Should include tokens for:
- identifiers
- literals
- operators
- delimeters
2. Initialize a "convert_to_string" function that converts the tokens to 
	string (for testing purposes). 
3. Write a general, process_tokens function that iterates over the input and generates 
	new tokens from the strings in input file.
4. Cover all cases for non-literals.
5. Cover cases for literals (symbols and numbers).

<h3>The Parser</h3>

<h2>The Back End</h2>

<h3>Creating the Byte code</h3>

<h3>Creating the Native Code (via a mini-compiler)</h3>

<h3>Runtime Responsabilities</h3>

**Note:** Still not really sure what these are... peep section 2.1.8 of https://craftinginterpreters.com/a-map-of-the-territory.html


