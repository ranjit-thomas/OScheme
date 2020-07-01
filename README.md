
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

<h3>Not Yet Implemented (Be sure to update above trees when I do):</h3>
- ERROR HANDELING!!!!!
- Negative Numbers
- Record
- Booleans
- SemiColons
- Strings
- Quote (super important)
- Symbols that are expanded to include non-alphabetic characters

<h2>Plan for Work Flow:</h2>
**Setting Up UserInteraction**
1. Set up a main function that looks exclusively for one or zero arguments.
2. Set up a function to call when in interactive mode.
3. Set up a function to call when in input-file mode.
4. Set up a generic, "run" function.

**The Lexer**
1. Define tokens in a file titled "token.ml".  Should include tokens for:
- identifiers
- literals
- operators
- delimeters
2. Initialize a "convert_to_string" function that converts the tokens to 
	string (for testing purposes). 