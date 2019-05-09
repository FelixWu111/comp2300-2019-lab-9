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
  
  bl blink

  end:
  nop
  b end



  blink:
  loop:
  bl red_led_on

  @set the SYST_RVR
  ldr r3, =0xE000E014
  ldr r4, [r3]  
  ldr r4, =20000
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
  ldr r4, =20000
  str r4, [r3]
  
  ldr r0, =0xE000E010
  mov r1, 0
  mov r2, 16
  bl read_bit
  
  cmp r0, 1 
  beq loop
  b empty


  

  

.size main, .-main