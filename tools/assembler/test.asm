; alp to calculate fibonacchi number
ldr r0 #0h00
ldr r1 #0h01
ldr r7 #0h0a
main:
    ldr r6 r1
    add r1 r0
    ldr r0 r6
    sub r7 #0h01
    cmp r7 #0h00
    je  l1
    jmp main
l1:
    str r1 0h8000 ; led
end:
    jmp end

