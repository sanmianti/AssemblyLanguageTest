;实验5 编写、调试具有多个段的程序
;
;（3）将下面的程序编译、连接，用debug加载、跟踪，然后回答问题。

assume cs:code, ds:data, ss:stack 

code segment
		
start:	mov ax, stack
		mov ss, ax
		mov sp, 16
		
		mov ax, data
		mov ds, ax
		
		push ds:[0]
		push ds:[2]
		pop ds:[2]
		pop ds:[0]
		
		mov ax, 4c00h
		int 21h

code ends

data segment
		dw 0123h, 0456h
data ends

stack segment
		dw 0, 0
stack ends

end start

;（1）CPU执行程序，程序返回前，data段中的数据为多少？
;答：值未变：
;0123h, 0456h
;
;（2）CPU执行程序，程序返回前，cs=____、ss=____、ds=____。
;答：cs = 076A， ss = 076E，ds = 076D
;
;（3）程序加载后，code段的段地址为X,则data段的段地址为____，stack段的段地址为____。
;答：data段的段地址为X+3，stack段的段地址为X+4。
;
