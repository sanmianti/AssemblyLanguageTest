;实验6 实践课程中的程序
;
;（6）编程，将datasg段中每个单词的前4个字母改为大写字母。
;
;本实验练习[bx+si+idata]的寻址方式。
;
assume cs:codesg, ss:stacksg, ds:datasg

stacksg segment
		dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
		db '1. display      '		;16个字节
		db '2. brows        '
		db '3. replace      '
		db '4. modify       '
datasg ends

codesg segment

start:	mov ax, datasg		;初始化栈段
		mov ds, ax
		
		mov ax, stacksg		;初始化栈段
		mov ss, ax
		mov sp, 16
		
		mov bx, 0
		mov cx, 4			;外层循环执行次数
		
	s0:	mov si, 0
		push cx
		mov cx, 4
	
	s1:	mov al, [bx+si+3]	;取一个字符
		and al, 11011111B	;ASCII码转大写
		mov [bx+si+3], al	;存转换后的字符
		inc si
		
		loop s1
		
		pop cx
		add bx, 16
		loop s0
		
		mov ax, 4c00h
		int 21h

codesg ends
end start

