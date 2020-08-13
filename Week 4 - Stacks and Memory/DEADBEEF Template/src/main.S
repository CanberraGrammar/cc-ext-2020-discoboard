.syntax unified
.global main

.type main, %function
main:
  
  ldr r0, =blankSpace
  ldr r1, =0xDEADBEEF
  str r1, [r0]

  b main

.size main, .-main

.data
  blankSpace:
      .word 0x0
  