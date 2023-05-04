main:
  ldr r6 #0h30
  ldr r7 #0h00
  ldsp r67 
	ldr r0 #0h00
	inc r0
  push r0
  pop r1
	str r1 0h8000
end:
	jmp end
