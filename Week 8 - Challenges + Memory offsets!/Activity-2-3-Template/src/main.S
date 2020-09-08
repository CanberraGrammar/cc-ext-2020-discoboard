.syntax unified
.global main
.type main, %function
main:
    bl init                         
    mov r1, #0                      
.size main, .-main

.type loop, %function
loop:                               
    add r1, #1                      
    
    mov r0, r1                        
    bl generate_wave                

    push {r1}
    bl BSP_AUDIO_OUT_Play_Sample    
    pop {r1}

    cmp r1, #100 @varies with the specific wave (samples/wave)
    blt loop                        
    sub r1, #100 @varies with the specific wave (samples/wave)

    b loop                          
.size loop, .-loop

.type generate_wave, %function
generate_wave:
    cmp r0, #50 @varies with the specific wave (half of samples/wave)
    bgt else
    push {r1}
    ldr r1, =#1200 @varies with the specific wave (60000 / (half of samples/wave))
    mul r0, r1
    ldr r1, =#30000
    sub r0, r1
    pop {r1}
    bx lr       
    else:      
    push {r1}
    mov r1, #50 @varies with the specific wave (half of samples/wave)
    sub r0, r1, r0
    ldr r1, =#1200 @ varies with the specific wave (60000 / (half of samples/wave))
    mul r0, r1
    ldr r1, =#30000
    add r0, r1
    pop {r1}
    bx lr             
.size generate_wave, .-generate_wave