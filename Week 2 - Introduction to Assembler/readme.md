# Week 2 -- Introduction to Assembler
## From Higher Level Languages to Assembly
Assembly is in many ways like a watered down version of any high level languages you may already know. This means, everything you can do in something like Python, is possible in assembly. But, like any other language, the syntax is specific, and needs to be learnt.

We'll go through a few examples of code in Python, and Assembly to ease you into the syntax, then, move on to activities for the day.

### Variables
Unlike a language like Python, ARM Assembly doesn't really have "variables". Instead we have 3 different ways of storing and using data, that are quite context sensitive. For example:

```python
x = 100
y = x * 50
```
Is difficult to directly replicate in Assembly. However, using registers, we can end up with something that achieves the same result:

```armasm
mov r0, #100 @ set r0 to 100
mov r1, #50  @ set r1 to 50
mul r1, r0   @ set r1 to itself * 100
```

This code makes use of *registers* -- 12 general use "global variables" that are available to us at all times.

Each register is actually *on the CPU*, and therefore, accessing data on them is extremely fast. Furthermore, almost all instructions put results directly into registers.

For this session, we'll focus mainly on registers.

#### Two's Complement (Reading for those who are interested)

The discoboard (and by extension, Visual Studio Code / PlatformIO) don't actually know if you want to store a negative number, or a positive number. As a result, if you are storing a negative number in a register, and you view it in the Registers pane in PlatformIO, you'll see a large positive number, instead of a negative number.

This is as a result of how computers represent negative numbers. As you may already know, computers use binary to represent numbers. 

**But WHY?**

This, is effectively, a series of "ones and zeros", that represent the different powers of two we need to add in order to produce a specific number.

For example, if we wanted to store a 13 with a 4 bit computer (real computers are usually 32/64 bits usually, for context (Even your discoboard!)), we'd do it like this:

`1101` meaning `(1 x 8) + (1 x 4) + (0 x 2) + (1 x 1)`.

Negative numbers are a bit more complex though. Ideally, any system we would use for representing negative numbers would have a few traits:
1. It would only have one zero
2. It would allow us to add one to negative one, and reach zero
3. It would allow us to subtract from positive numbers, by adding negative numbers

The system we use to do this, which satisfies all of these criteria, is called Two's Complement.

It works like this:

To represent a negative number, we take the positive representation in binary (let's use 5 here):
`0101` is 5 in binary

Now, we flip all of the bits (this is called a "1's complement" representation):
`0101` becomes `1010`

Finally, we add 1:
`1010` + `1` is `1011`

Now, we've got `-5` represented in binary, let's see what happens when we add 5:
```
    0101
        +
    1011
    ----
  1 0000
```
We get rid of the leftmost bit (the "overflow" bit), and we've come to the correct answer: `5 + (-5)` is indeed `0`.

Let's now try with `6 + (-5)`:
6 in binary is: `0110`
```
    0110
        +
    1011
    ----
  1 0001
```
Once again, we ignore the overflow to the left, and we're left with `1`, and again, that's the correct answer.

As such, 2's complement allows us to represent both positive and negative numbers, without the computer even needing to know if a number is positive or negative when performing addition. This means addition hardware can be used for subtraction, and that subtraction hardware only needs to convert the second operand of a subtraction operation into two's complement then use the addition hardware, and it means we have a continuous set of numbers without overlapping zeros, or any of the other issues that plague other binary integer representation techniques. It's cheap computationally and physically, but as a design consequence, it means the discoboard doesn't know whether we're using negative numbers or not. It means our register view will often present data to us in a way we don't necessarily like too.

Hopefully you understand it all a bit better. If not, doing some practice with it will help, and you can always ask your tutors. It's not going to be a super important part of this course, though, so don't stress too much over it.

Windows Calculator's programmer mode is a pretty good tool to use to convert the unsigned hexadecimal representation offered by the Registers Pane into a signed number that's easier to understand. If you don't, then this website: [Cryptii](https://cryptii.com/pipes/integer-encoder) also works well -- just make sure you're using the `32-bit signed integer (I32)` option

### Basic Math

```python
x = 100

x += 10
x -= 15

x *= 3
x /= 3
```

ARM Assembly, broadly speaking, supports 4 mathematical operations -- Addition, Subtraction, Multiplication, and Division.

```armasm
mov r0, #100    @ x = 100

add r0, #10     @ x += 10
sub r0, #15     @ x -= 15

push {r1}       @ this allows us to preserve the state of r1, but also use it
mov r1, #3      @ move 3 into r1, so we can do multiplication and division

mul r0, r1      @ x *= 3
sdiv r0, r1     @ x /= 3
pop {r1}        @ restore the state of r1
```

You may notice some differences between each instruction:
For example, `add` can be written out as `add r0, #10`, but `mul` and `sdiv` aren't written out like this.

All of these instructions support this format -- `<instruction> destination register / operand 1, register operand 2`, but not all instructions support the use of "immediate" values. That is, `<instruction> destination register / operand 1, <value>`.

If we look at the [ARM-7 Cheat Sheet](https://github.com/CanberraGrammar/cc-ext-2020-discoboard/blob/master/ARMv7-cheat-sheet.pdf), we can see under "Addition" that there are two entries for the add instruction. `add{s}<c><q> {<Rd>,} <Rn>, <Rm>`, and `add{s}<c><q> {<Rd>,} <Rn>, #<const>`. The first of these, is in reference to using the instruction like this:

```armasm
mov r0, #10
mov r1, #20
add r0, r1
```

and the second is the way that we used it in the code above -- with an immediate, inline value.

For `mul`, though, there is only one entry: `mul<c><q> {<Rd>,} <Rn>, <Rm>`. This is because, as stated, the `mul` instruction cannot be used with "immediate values".

### Control Flow

The next important parts of any language relate to how we turn a concept of a program into a logical set of steps that the computer can "understand". The way we structure these steps broadly forms the concept of "control flow". This is everything from `if` statements, to functions and loops.

#### Branching and labels

Branching -- or the term "branch" in general (as is applies to ARM assembly) is somewhat of a misnomer.

As you may know, as a computer is running a program (in most languages) it is effectively stepping through each line of code one by one. The order in which it reaches certain lines can be modified by changing the control flow of the program. For instance, if the condition on an if statement in Python is False, the computer will skip over the if statement to either the first elif, or the else statement associated with that if statement, or to after the if statement.

This makes sense -- if the condition on an if statement is false, obviously there's no reason to run the code that exists inside it.

Similarly, loops will modify control flow -- forcing the computer to continue doing the same thing over and over, until either the loop condition is false, or something like a "break" is used.

In assembly, then, anything\* that stops the computer (or discoboard) from executing the code in the order it's written (that is, top to bottom), is a *branch*. So loops contain branches, as do conditionals, function calls, and other pretty standard aspects of programming.

Often, in assembly, we branch *to* a "label". A label, is a string of text -- free of whitespace, ending in a `:`. For example:

```armasm
main:       @ main label
    nop     @ do nothing
    b main  @ loop back to top of main
```

It's really important, at this point, to also understand the following:

Labels are global! This means, that you cannot have two labels in one program that have the same name, without one overriding the other.

#### Conditions

Here's a simple piece of Python code:

```python
x = 100
if x == 100:
    #do something here!
else:
    #do something else!
```

Here's a replication of that in assembly:
(Indentation is out of stylistic choice)

```armasm
mov r0, #100 @get a starting value into 'x'
cmp r0, #100 @compare 'x' to 100 (the condition on the if statement)

bne else @if r0 is not 100, we have to go to the else condition
if:
    @ do something here!
    b out

else:
    @ do something else!
    b out

out:
```

Once again, this code obviously does not look exactly like the Python code it is modelled after, but, there are essentially 3 new things going on.

First, we have `cmp`. `cmp` acronyms for **c**o**mp**are, and allows us to compare two numbers, and stores the result in the *Program Status Register*, although, we're not going to worry about that for now. The point is, now, we can use 𝑪𝒐𝒏𝒅𝒊𝒕𝒊𝒐𝒏 𝑪𝒐𝒅𝒆𝒔 in order to execute certain instructions based on the result of our comparrison.

In the [ARM-7 Cheat Sheet](https://github.com/CanberraGrammar/cc-ext-2020-discoboard/blob/master/ARMv7-cheat-sheet.pdf), these are all listed on page 2 ("Condition Codes").

Back to the example though -- we have the line "`bne else`". Here, `b` is the base instruction: and it means "**b**ranch", and the condition code is "`ne`" (**n**ot **e**qual). Hence, if `r0` is not equal to `100`, we will branch to the `else:` label. Branching on the false condition allows us to write code that looks nicer, but it is of course possible to branch on the "True" condition too:

```armasm
mov r0, #100 @ get a starting value into 'x'
cmp r0, #100 @ compare 'x' to 100 (the condition on the if statement)

beq if       @ if r0 is not 100, we have to go to the else condition
b else       @ if we've got to this line, then eq must be false, so we jump to the else
if:
    @ do something here!
    b out

else:
    @ do something else!
    b out

out:
```

From here on, though, we'll continue branching on false.

If we were going to write code like this in real life, we'd have to make sure that our labels: `if`, `else` and `out` are only used in this section of code, as otherwise, this likely would not work as expected.

#### Loops

Here's a simple piece of Python code:

```python
x = 0
while (x < 100):
    x = x + 1
#another line
```

Here's a replication of that in assembly:

```armasm
mov r0, 0           @ initialize 'x'
loop:
    cmp r0, #100    @ compare 'x' to 100
    bge out         @ >= is the opposite of <
    add r0, 1       @ add 1 to r0
    b loop          @ continue the loop
out:
@another line
```

Once again, we're using a strategy of testing for the opposite of the loop condition, and leaving the loop when this becomes true.

Generally, post-test loops look better (and are more intuitive) in assembly. In this case, a post test version might look like this:

```armasm
mov r0, 0           @ initialize 'x'
loop:
    add r0, 1       @ add 1 to r0
    cmp r0, #100    @ compare 'x' to 100
    blt loop        @ if 'x' is less than 100, continue looping
@another line
```

Obviously, this is no longer exactly the same (in what it does) as our Python code. But in this case, the logical difference between using a pre and post test loop is pretty inconsequential for our code (as we're setting r0 to 0 immediately above the loop anyway).

## Activities

### Starting Simple -- Doing basic math
To get used to the basics, and learn how to use the register view mode in PlatformIO, the first thing to do is to do some basic math.
Work to replicate this simple Python code:

```python
age = #put your age you turn this year!
number = #put the last digit of your birthyear here!
x = #digit sum of current year

n = age * 4
n += 24
n /= 2
z = number * 7
z += 42
x *= x
n *= 49
n /= 7
z *= 2
n += z

n /= x
n /= 4
print(n)
```

Obviously, printing `n` isn't going to be possible, but, use the Register view in Visual Studio Code to view the answer in whichever register you put the result.

### Looping to multiply

In order to get a grasp of loops, the next activity is to write a program that will multiply two numbers together, without using the `mul` instruction.

In order to do this successfully, you'll need to repeatedly add one number to itself, or "multiply by repeated addition".

### Factorial

Hopefully everyone knows that the factorial of a number is the number produced when we multiply together all of the natural numbers up to and including that number. For instance, 3 factorial is calculated as `3 * 2 * 1`. Similarly, 4 factorial is `4 * 3 * 2 * 1`.

Write a program that will calculate the factorial of whatever number is in r0.

### Fibonacci

The Fibonacci sequence is a sequence of numbers that follow this pattern:

f0 = 0
f1 = 1
f2 = f1 + f0
f3 = f2 + f1
...
fn = (fn-1) + (fn-2)

Write a program that will calculate the nth (stored in r0) number in the Fibonacci sequence. Test with the 35th number: `9227465`.

### Factorial, but extension

Factorial is a problem commonly used to teach people about how recursion works. Take this python snippet for example:

```python
def fact(a):
    if (a <= 0):
        return 1
    return a * fact(a-1)
```

It recursively calculates factorials based on the idea that `5!` (5 factorial) is the same as `5 * 4!`, etc.

Recursion is possible in assembly too, but in order to pull it off you'll need a few things:

`push {<registers>}` will put the values in all of the listed registers (listed as `r0-r6` (meaning all registers from r0-r6 recursive), or `r0,r2,r4` etc (meaning the listed registers)) onto the "stack". This effectively saves them, so they can be restored.
`pop {<registers>}` will put the values stored on the stack back into the registers.
`bl label` will branch (like `b`), except, the `lr` register will be populated with the address of the instruction after the `bl` instruction. This is analogous to "calling a function", and would be needed for a recursive implementation.
`bx lr` will branch to the location stored in `lr`. Note that `lr` will not change after this branch back happens, and as a result, if you `bx lr` again, you'll jump back to the point you just jumped back to. A quick hint would be to make sure that you `push` `lr` to the stack with `push {lr}` before using `bl`, and that you remember to `pop {lr}` after the `bl` instruction.

We don't *expect* anyone to complete this, but if you do, let us know, and we'll give you more activities.