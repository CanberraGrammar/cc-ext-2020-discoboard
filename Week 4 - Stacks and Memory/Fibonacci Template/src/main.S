.syntax unified
.global main

.type main, %function
main:
  
  mov r0, 3 @ nth number of fibonacci
  bl fibonacci
  nop

  b main

.size main, .-main


.type fibonacci, %function
fibonacci:

  @ Your code here

.size fibonacci, .-fibonacci
  