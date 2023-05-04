
main:
    ldr r0 list h
    ldr r1 list l

    ldr r2 @r01
    str r2 0h8000
    add r1 #0h01

    ldr r2 @r01
    str r2 0h8000
    add r1 #0h01
    
    ldr r2 @r01
    str r2 0h8000
    add r1 #0h01
    
    ldr r2 @r01
    str r2 0h8000
    add r1 #0h01

end:
    jmp end

check_and_inc:
    add r1 #0h01

list:
    .b 0h01
    .b 0h02
    .b 0h03
    .b 0h04

