loop1:
  ldr r0 #0h31 ; 1
  str r0 0h8002
  
  ; start tx
  ldr r1 #0h01
  str r1 0h8001

  ; wait for tx
lp1:
  ldr r1 0h8001
  and r1 #0h02
  cmp r1 #0h00
  jne lp1

  ; reset tx
  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l1:
  dec r7
  cmp r7 #0h00
  jne l1


; \n 

  ldr r0 #0h0a ; \n
  str r0 0h8002

  ldr r1 #0h01
  str r1 0h8001

lp7:
  ldr r1 0h8001  
  and r1 #0h02
  cmp r1 #0h00
  jne lp7

  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l7:
  dec r7
  cmp r7 #0h00
  jne l7

loop2:
  ldr r0 #0h39 ; 9
  str r0 0h8002
  
  ; start tx
  ldr r1 #0h01
  str r1 0h8001

  ; wait for tx
lp2:
  ldr r1 0h8001
  and r1 #0h02
  cmp r1 #0h00
  jne lp2

  ; reset tx
  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l2:
  dec r7
  cmp r7 #0h00
  jne l2


; \n 

  ldr r0 #0h0a ; \n
  str r0 0h8002

  ldr r1 #0h01
  str r1 0h8001

lp6:
  ldr r1 0h8001  
  and r1 #0h02
  cmp r1 #0h00
  jne lp6

  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l6:
  dec r7
  cmp r7 #0h00
  jne l6


jmp loop1