# Week 9 - Esoteric Languages and Code Golf

## Esoteric

Something we don't hear much about but might see while doing code golf, is esoteric languages. They're weird and wacky, but ultimately can be incredibly satisfying. An example of an esoteric language is available in the file [slang.py](slang.py).
Your challenge is to, using this language, complete a few code golf challenges.

Documentation for the language is available here: [documentation for slang](slang-documentation.md).

### Challenge 1 - Hello World
Although it's cliche, your first challenge is to write a line of code in this language, that will just say "Hello World". This is mainly to get to grips with some of the syntax.

### Challenge 2 - Hello x 10
In order to get a better understanding of how to use control structures, the challenge is now to say Hello, but 10 times, each on a separate line. This should be doable with a loop, but will require you to use both the temporary and value registers.

### Challenge 3 - Summation
Write a program that calculates the sum of all numbers from 1 to a given number (loaded in at the start with an `L` instruction), and prints it to the console.

### Challenge 4 - Fibonacci
Write a program which takes a number (n) with an `L` instruction and then produces the nth value of fibonacci (0,1,1,2,3,5,8...), printing each number along the way.


---

## Code Golf

Today we are going to do some ARM code golf. We have written some of these programs previously so try to modify/optimise your programs.

Do not modify the templates given other than adding your solution between comments or adding functions below.
Try to solve the challenges using the least line, not characters.

### Challenge 1 - Factorial
Write a program which takes a number (n) in register 0 and then produces the factorial of that number and leaves it in register 1.

### Challenge 2 - Fibonacci
Write a program which takes a number (n) in register 0 and then produces the nth value of fibonacci (0,1,1,2,3,5,8...) and leaves it in register 1.

e.g. if input is 0, return 0. If input is 6, return 8.

### Challenge 3 (Hard) - Wave Generation
Using the template provided, write a program to produce a wave (any shape) of 480hz.