;实验6 实践课程中的程序
;
;（1）在codesg中填写代码，将datasg中的第一个字符串转换为大写，
;第二个字符串转化为小写。
;
;将ASCII码的第五位置为0，变为大写字母
;将ASCII码的第五位置为1，变为小写字母

assume cs:codesg, ds:datasg

datasg segment
		db 'BaSiC'
		db 'iNfOrMaTiOn'
datasg ends

codesg segment

start:	mov ax, datasg
		mov ds, ax 
		
		mov bx, 0
		mov cx, 5
	
	s1:	mov al, [bx]
		and al, 11011111B
		mov [bx], al
		inc bx
		loop s1
		
		mov bx, 5
		mov cx, 11
		
	s2:	mov al, [bx]
		or al, 00100000B
		mov [bx], al 
		inc bx 
		loop s2
		
		mov ax, 4c00h
		int 21h
codesg ends

end start
