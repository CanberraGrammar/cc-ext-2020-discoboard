# Week 7 - Reintroducing Memory

Hopefully everyone got triangle waves working last week. If not, here's some code to get you started:

This code generates a triangle wave at a frequency of 480hz.

```armasm
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
```

## Exercise 1

To get started, we're going to try to make the above code a little more generic. Lines that are specific to the implementation -- that is, specific to a 480hz wave -- have been marked in the above code. The aim is to turn that code into code that'll allow us to easily switch to waves of different frequencies.

Most of the code that we need to edit will be in `generate_wave`. Here, we need to: calculate the change between each sample of the wave (`1200` in the above example), and calculate the middle sample (`50` in the above example).

We also need to make a change to our loop too: `cmp r1, #100` and `sub r1, #100` need to change based on the number of samples in the wave.

For now, we're only going to change our function so that it works based on waves specified by a specific sample number (/ number of samples), stored in a register of your choice.

## Exercise 2

Let's make a quick modification to what we did for Exercise 1 -- now, instead of storing a sample number, we're going to allow the frequency of the wave to be specified by storing an actual frequency in the register you chose for Exercise 1.

Compare the sound your code makes to that which your neighbor's sound makes given the same frequency, in order to make sure your code works.

## Exercise 3

Finally, let's recall the way we used memory in week 4:

With this snippet down the bottom of the code:
```armasm
.data
    storage:
    .word 0xDEADBEEF
```

We can use this to load the data in `storage` into a register:

```armasm
ldr rz, =storage
ldr rx, [rz]
```

where rz and rx are both registers (they can be the same).

For this task, then, we're going to try to make our current code even more generic. To do this, we'll store the frequency in memory, then load it before calling our `generate_wave` function.

As a quick rule here -- we're going to need to load from memory every time the loop runs -- because the end goal here is going to be being able to switch frequencies easily.

Once this is working, you're done for the week -- help your neighbors do the same thing, or start to think about other numbers you could store in memory -- maybe the total volume range (`60000` in this case), or the type of wave (we could also, for example, use square waves).