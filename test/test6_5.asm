;实验6 实践课程中的程序
;
;（5）编程，将datasg段中每个单词改为大写字母。
;
;本实验练习[bx+si]的寻址方式。
;
assume cs:codesg, ds:datasg, ss:stacksg

datasg segment 
		db 'ibm             '
		db 'dec             '
		db 'dos             '
		db 'vax             '
datasg ends

stacksg segment			;定义一个段，用来做栈段，容量为8个字
		dw 0,0,0,0,0,0,0,0
stacksg ends

codesg segment

start:	mov ax, datasg	;初始化数据段
		mov ds, ax 
		
		mov ax, stacksg	;初始化栈段
		mov ss, ax
		mov sp, 16
		
		mov bx, 0
		mov cx, 4
		
	s0: mov si, 0		;外层循环，遍历行（4行）
		push cx			;临时保存cx的值 
		
		mov cx, 3
	s1:	mov al, [bx+si]	;内层循环，遍历列（3列）
		and al, 11011111B
		mov [bx+si], al
		inc si 
		
		pop cx 			;恢复外层循环cx的值
		add bx, 16
		loop s0
		
		mov ax, 4c00h
		int 21h

codesg ends
end start

