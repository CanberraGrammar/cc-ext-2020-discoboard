.syntax unified
.global main

.type main, %function
main:
  
  mov r0, 5 @ parameter
  bl factorial
  nop

  b main

.size main, .-main


.type factorial, %function
factorial:

  @ Your code here

.size factorial, .-factorial
  