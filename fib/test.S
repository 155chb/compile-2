    .arch armv7-a
    .section    .rodata
    .align 2
_str0:                      @ 声明几个字符串常量
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
    push    {fp, lr}        @ 保存寄存器，与实例代码不同，这里保存了lr寄存器
    add     fp, sp, #4      @ 设置栈顶指针，sp=fp+4，给lr寄存器保留4字节内存
    str     r1, [sp, #-4]!  @ 保存r1寄存器，r1寄存器是局部变量（继续调用fib时会被修改），需要保存
    sub     sp, sp, #4      @ 按照8字节对齐，给r0预留4字节内存
    str     r0, [fp, #-12]  @ 保存r0寄存器，后续会被不断修改
    ldr     r0, [fp, #-12]  @ 恢复r0寄存器
    cmp     r0, #3          @ 判断n是否小于3
    blt     .L2             @ 如果是，则跳转到.L2
    sub     r0, r0, #2      @ 计算n-2
    bl      fib             @ 递归调用fib(n-2)
    mov     r1, r0          @ 保存fib(n-2)的值
    ldr     r0, [fp, #-12]  @ 恢复r0寄存器
    sub     r0, r0, #1      @ 计算n-1
    bl      fib             @ 递归调用fib(n-1)
    add     r0, r0, r1      @ 计算fib(n)=fib(n-2)+fib(n-1)
    b       .L3             @ 跳转到.L3
.L2:
    mov     r0, #1          @ 计算fib(n)=1
.L3:
    add     sp, sp, #4      @ 恢复栈顶指针
    ldr     r1, [sp], #4    @ 恢复r1寄存器
    pop     {fp, pc}        @ 恢复寄存器，并跳转至下一条指令

    .global main
main:
    push    {fp, lr}        @ 保存寄存器
    add     fp, sp, #4      @ 设置栈顶指针
    sub     sp, sp, #8      @ 按照8字节对齐，给r0预留4字节内存
loop:
    ldr     r0, _bridge     @ 读取字符串指针，"input n:\0"
    bl      printf          @ 调用printf函数
    ldr     r0, _bridge+4   @ 读取字符串指针，"%d\0"
    add     r1, fp, #-12    @ 读取n的地址，即&n=fp-12
    bl      __isoc99_scanf  @ 调用scanf函数
    cmp     r0, #0          @ 判断输入是否成功读入
    beq     end             @ 如果是，则跳转到end
    ldr     r0, [fp, #-12]  @ 读取n的值
    bl      fib             @ 调用fib函数
    mov     r1, r0          @ 将fib(n)的值作为printf函数的第2个参数
    ldr     r0, _bridge++8  @ 读取字符串指针，"fib(n)=%d\n"
    bl      printf          @ 调用printf函数
    b       loop            @ 跳转到loop，继续读取输入
end:
    mov     r0, #0          @ 返回0
    add     sp, sp, #8      @ 恢复栈顶指针
    pop     {fp, pc}        @ 恢复寄存器，并跳转至下一条指令

_bridge:                    @ 字符串指针
    .word   _str0
    .word   _str1
    .word   _str2

    .section .note.GNU-stack,"",%progbits