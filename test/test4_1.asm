;实验4 [bx]和loop的使用
;
;（1）编程，向内存0:200~023F依次传送数据0~63（3FH）。

assume cs:code

code segment

	mov bx, 0		;初始值
	mov cx, 64		;循环次数
	mov ax, 0020h	
	mov ds, ax		;将段地址送入ds寄存器	
	
s:  mov ds:[bx], bx	;将数据送入ds:bx指向的内存单元
	inc bx			;bx+1
	loop s			;判断循环是否结束
	
	mov ax, 4c00h
	int 21h
	
code ends
end