
Context: What makes a Scheme program?
=====================================

S-Program := S-Expression

S-Expression := S-Symbol | ([List of S-Expression]) | S-Value

S-Value := int | boolean | string


DesignPlan
==========

NOT YET IMPLIMENTED:
--------------------
- Record
- Booleans
- SemiColons
- Strings
- Quote (super important)
- Non-Int Numbers


Plan for WorkFlow:
------------------
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