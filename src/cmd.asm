main:
	ldr r6 #0h80
	ldr r7 #0h01		; uart control reg addr
	
	ldr r0 #0h41 		; data to send 'A'
	str r0 0h8002 		

	ldr r0 #0h01 		; set write signal
	str r0 @r67

	ldr r0 #0h00
	str r0 @r67		

l1:
	ldr r1 @r67			; read uart control reg
	cmp r1 #0h02		; ack from uart

	jne l1


	ldr r0 #0h42 		; data to send 'B'
	str r0 0h8002 		

	ldr r0 #0h01 		; set write signal
	str r0 @r67

	ldr r0 #0h00
	str r0 @r67	

l2:
	ldr r1 @r67			; read uart control reg
	cmp r1 #0h02		; ack from uart

	jne l2

	ldr r2 #0hff
	str r2 0h8000

end: jmp end
