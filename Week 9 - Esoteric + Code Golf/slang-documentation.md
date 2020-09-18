# Language Spec

## Runtime

This language runs in an extremely basic bytecode interpreter, and has limited memory available to it.

The language has two registers -- a value register (`vr`) and a temporary register (`tr`).

The value register is affected by instructions, but with the exception of the swap instruction `s`, `tr` will always remain the same.

A stack/queue is available to be used as memory space. The stack/queue may have values enqued/pushed onto it, and dequeued or popped off of it. Apart from this, no more space for values or variables exists.

## Instructions

`+` -> Push vr to the stack

`-` -> Pop from the stack into vr

`*` -> copy the value at the top of the stack into vr

`q` -> dequeue top stack element into vr

`=<char>` -> set vr to the character following the = sign

`L<number>;` -> set vr to the number between L and ;

`[`,`]` -> repeat actions between square brackets forever

`n<cond>` -> skip next instruction depending on condition

`b` -> break from the innermost loop

`i` -> increment vr

`d` -> decrement vr

`s` -> swap values in vr and tr

`e` -> terminate program

`p` -> print char at value of vr to output

`P` -> print the value of vr as an integer

`N` -> print a newline character

`M` -> multiply vr by tr, store in vr

`A` -> add vr to tr, store in vr

`S` -> subtract tr from vr, store in vr

## Conditions
`=` -> vr = tr

`<` -> vr < tr

`>` -> vr > tr

`0` -> vr = 0

`1` -> vr = 1

`n` -> vr != 0

## Running code

In order to run a line of code with slang, open a terminal window, and navigate to the folder containing slang.py, and use the command:

`python slang.py "<your code here>"`.

To confirm it's working, try running:

`python slang.py "L10;PNP"`.

This should print `10` to your console twice, each time on a new line.

## Examples

`=asL10;[dspsn0]=hp=!p`
will print:
`aaaaaaaaaah!`

Explained, what this is doing is as follows:
* Load `a` into value register
* Swap value into temp register
* Load 10 into value register
* Loop
    * decrease the value register
    * swap the value register with the temp register
    * print the value in the value register (`a`)
    * swap the value register with the temp register
    * break out of the loop if the value in the value register is 0
* load h into the value register
* print the value
* load ! into the value register
* print the value