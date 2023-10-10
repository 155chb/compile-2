    .arch armv7-a
    .section    .rodata
    .align 2
_str0:
    .ascii "input n:\0"
    .align 2
_str1:
    .ascii "%d\0"
    .align 2
_str2:
    .ascii "fib(n) = %d\n\0"
    .align 2
    .text

    .global fib
fib:
    push    {fp, lr}
    add     fp, sp, #4
    str     r1, [sp, #-4]!
    sub     sp, sp, #4
    str     r0, [fp, #-12]
    ldr     r0, [fp, #-12]
    cmp     r0, #3
    blt     .L2
    sub     r0, r0, #2
    bl      fib
    mov     r1, r0
    ldr     r0, [fp, #-12]
    sub     r0, r0, #1
    bl      fib
    add     r0, r0, r1
    b       .L3
.L2:
    mov     r0, #1
.L3:
    add     sp, sp, #4
    ldr     r1, [sp], #4
    pop     {fp, pc}

    .global main
main:
    push    {fp, lr}
    add     fp, sp, #4
    sub     sp, sp, #8
loop:
    ldr     r0, _bridge
    bl      printf
    ldr     r0, _bridge+4
    add     r1, fp, #-12
    bl      __isoc99_scanf
    cmp     r0, #0
    beq     end
    ldr     r0, [fp, #-12]
    bl      fib
    mov     r1, r0
    ldr     r0, _bridge++8
    bl      printf
    b       loop
end:
    mov     r0, #0
    add     sp, sp, #8
    pop     {fp, pc}

_bridge:
    .word   _str0
    .word   _str1
    .word   _str2

    .section .note.GNU-stack,"",%progbits