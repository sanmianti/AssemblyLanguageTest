;实验5 编写、调试具有多个段的程序
;
;（5）程序如下，编写code段中的代码，将a段b段中的数据依次相加，将结果保存在c段中

assume cs:code 

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends

c segment
	db 0,0,0,0,0,0,0,0
c ends 

code segment 
	
start:	
	
		mov ax, a 
		mov ds, ax
		mov ax, b
		mov ss, ax 
		mov ax, c 
		mov es, ax
		
		mov cx, 8
		mov bx, 0
		
	s: 	mov ah, ds:[bx]
		add ah, ss:[bx]
		mov es:[bx], ah 
		inc bx
		loop s
		
		mov ax, 4c00h
		int 21h
	
code ends
end start