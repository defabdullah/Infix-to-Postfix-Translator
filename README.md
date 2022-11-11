# Infix-to-Postfix-Translator
CMPE260 Principles of Programming Languages Homework. Parse an infix notation and convert to postfix notation writtten in Racket(Functional Programming Language).

After compiling main.rkt file, predicates can be given.
## Example Predicates

\>  ('a := 7 --) @ (a * ('a := 4 --) @ (a + 7)) (now this is both a valid expression, and
can be evaluated, the result is 77)

\>  1 + 7 + 6 + 1 + 34 * (('x := 3 -- 'y := 6 --) @ (5 * (x + y + ('z := 'x --) @ (z)))) + 5  (result is 2060)
