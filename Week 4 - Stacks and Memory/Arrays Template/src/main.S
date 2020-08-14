.syntax unified
.global main

.type main, %function
main:
  
  
  nop

  b main

.size main, .-main


.data 
  ourArray:
    .word 0,0,0,0,0,0,0,0,0,0