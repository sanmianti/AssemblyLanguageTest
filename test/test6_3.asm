;实验6 实践课程中的程序
;
;（3）用si和di实现将字符串'welcome to masm'复制到它后面的数据区中。
;
; 可以一次拷贝一个字符，为了提升效率也可以一次拷贝两个字符（一个字）

assume cs:codesg, ds:datasg

datasg segment
		db 'welcome to masm!'
		db '................'
datasg ends

codesg segment
		
start:	mov ax, datasg		;指定数据段的段地址
		mov ds, ax
		
		mov si, 0
		mov di, 16
		
		mov cx, 16
		
	s:	mov al, [si]		;拷贝一个字符至al
		mov [di], al		;将字符复制至ds:[di]
		inc si
		inc di
		loop s
		
		mov ax, 4c00h
		int 21h

codesg ends

end start
