.syntax unified
.global main

.type main, %function
main:
  bl red_led_init
  @load the address for SYST_CSR
  ldr r8, =0xE000E010
  ldr r9, [r8]
  @then set the  0x0101 to enable the counter.
  orr r9, 0x0101
  str r9, [r8]
  
  bl blink_codepoint
  
  

  

    
  


  blink_codepoint:
  ldr r7, =morseD
  ldr r6, [r7]

  loop_part:
  adds r7, 4
  ldr r8, [r7]
  subs r6, 1
  cmp r8, 1
  beq dash
  bl blink_dot
  cmp r6, 0
  beq end
  b loop_part

  dash:
  bl blink_dash
  cmp r6, 0
  beq end
  b loop_part




  blink_dot:
  push {lr}
  loop:
  bl red_led_on
  @set the SYST_RVR
  ldr r3, =0xE000E014
  ldr r4, [r3]  
  ldr r4, =0x20000
  str r4, [r3]
  ldr r0, =0xE000E010
  mov r1, 0
  mov r2, 16
  bl read_bit
  cmp r0, 1 
  beq empty
  b loop
  empty:
  bl red_led_off
  @load the address for SYST_CSR
  @set the SYST_RVR
  ldr r3, =0xE000E014
  ldr r4, [r3]  
  ldr r4, =0x20000
  str r4, [r3]
  ldr r0, =0xE000E010
  mov r1, 0
  mov r2, 16
  bl read_bit
  cmp r0, 1 
  beq loopz
  b empty
  loopz:
  pop {lr}
  bx lr

  blink_dash:
  push {lr}
  loop2:
  bl red_led_on
  @set the SYST_RVR
  ldr r3, =0xE000E014
  ldr r4, [r3]  
  ldr r4, =0x60000
  str r4, [r3]

  ldr r0, =0xE000E010
  mov r1, 0
  mov r2, 16
  bl read_bit
  cmp r0, 1 
  beq empty2
  b loop2
  empty2:
  bl red_led_off
  @load the address for SYST_CSR
  @set the SYST_RVR
  ldr r3, =0xE000E014
  ldr r4, [r3]  
  ldr r4, =0x20000
  str r4, [r3]

  ldr r0, =0xE000E010
  mov r1, 0
  mov r2, 16
  bl read_bit
  cmp r0, 1 
  beq loopz2
  b empty2
  loopz2:
  pop {lr}
  bx lr
  
  
  end:
  nop
  b end

.size main, .-main
.data
morseD: 
.word 3, 1, 0, 0, 0, 0
