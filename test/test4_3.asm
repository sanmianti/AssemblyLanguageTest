;实验4 [bx]和loop的使用
;
;（3）下面的程序的功能是将“mov ax,4c00h”之前的指令复制到内存0:200处，
;补全程序。上机调试，跟踪运行结果。

assume cs:code

code segment

	mov ax, cs		;源程序首地址
	mov ds, ax
	mov ax, 0020h
	mov es, ax
	mov bx, 0
	mov cx, 0017h	;要复制字节的数量
	
s:	mov al, [bx]
	mov es:[bx], al
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
	
code ends
end

;提示：
;（1）复制的是什么？从哪里到哪里？
;答：
;以字节为单位复制源程序所对应的二进制码。从cs:0000复制到0020:0000。
;（2）复制的是什么？有多少个字节？你是如何知道要复制的字节的数量？
;答：
;通过U命令查看mov ax, 4c00h所在地址的偏移地址，拿该偏移地址减去ip的
;初始值即可获得要复制的字节的数量。