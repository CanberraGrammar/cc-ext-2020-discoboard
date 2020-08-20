.syntax unified
.global main

.type main, %function
main:
  bl init
  b loop
.size main, .-main

.type loop, %function
loop:
  nop @your code here
  @bl BSP_AUDIO_OUT_Play_Sample @
  b loop
.size loop, .-loop