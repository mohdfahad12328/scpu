main:
; H
  ; load H for tx
  ldr r0 #0h48 ; H
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

; E

  ; load E for tx
  ldr r0 #0h45 ; E
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

; L

  ; load L for tx
  ldr r0 #0h4c ; L
  str r0 0h8002

  ; start tx
  ldr r1 #0h01
  str r1 0h8001

  ; wait for tx

lp3:
  ldr r1 0h8001
  and r1 #0h02
  cmp r1 #0h00
  jne lp3

  ; reset tx
  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l3:
  dec r7
  cmp r7 #0h00
  jne l3

; L

  ; load L for tx
  ldr r0 #0h4c ; L
  str r0 0h8002

  ; start tx
  ldr r1 #0h01
  str r1 0h8001

  ; wait for tx

lp4:
  ldr r1 0h8001
  and r1 #0h02
  cmp r1 #0h00
  jne lp4

  ; reset tx
  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l4:
  dec r7
  cmp r7 #0h00
  jne l4

; O

  ; load O for tx
  ldr r0 #0h4f ; O
  str r0 0h8002

  ; start tx
  ldr r1 #0h01
  str r1 0h8001

  ; wait for tx

lp5:
  ldr r1 0h8001
  and r1 #0h02
  cmp r1 #0h00
  jne lp5

  ; reset tx
  ldr r1 #0h00
  str r1 0h8001

  ldr r7 #0hff
l5:
  dec r7
  cmp r7 #0h00
  jne l5

; \r

  ldr r0 #0h0d ; \r
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

  jmp main
