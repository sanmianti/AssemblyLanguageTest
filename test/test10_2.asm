;实验名称：解决除法溢出的问题
;
;应用举例：计算 1000000/10(F424H/01H)
;结果 (dx)=001H, (ax)= 86A0H, (cx)=0
assume cs:codesg, ss:stacksg

;声明8个字的连续内存空间用做栈
stacksg segment
	dw 8 dup (0)
stacksg ends

codesg segment
;=======================程序入口==================================
start:
	
	;初始化运行环境及参数
	;初始化栈
	mov ax, stacksg
	mov ss, ax
	mov sp, 16
	
	;声明参数并调用子程序
	mov dx, 0fh
	mov ax, 4240h
	mov cx, 0ah
	call divdw
	
	;退出程序
	mov ax, 4c00h
	int 21h
;=================================================================

;=====================不会发生溢出的16位除法运算==================
;子程序描述
;名称：divdw
;功能：进行不会产生溢出的除法运算，被除数为双字（dword）型，
;	   除数为单字（word）型，商为双字型，余数为单字型。
;参数：	（dx） = 被除数的高16位
;		（ax） = 被除数的低16位
;		（cx） = 除数
;返回：	（dx） = 商的高16位，
;		（ax） = 商的低16位
;		（cx） = 余数
;公式：X/N = int(H/N)*65536 + [rem(H/N)*65536 + L]/N。
divdw:
	push bx
	
	mov bx, ax	;(bx) = L
	mov ax, dx	;(ax) = H
	mov dx, 0	;(dx) = 0
	div cx		;(dx) = 0,(ax) = H, (cx) = N
	push ax		;(ax) = int(H/N)
	
	mov ax, bx	;(bx) = L
	div cx		;(dx) = rem(H/N),(ax) = L, (cx) = N
	mov cx, dx	;(dx) = rem{[rem(H/N)*65536 + L]/N}, (ax) = int{[rem(H/N)*65536 + L]/N}
	pop dx		;(ss:sp) = int(H/N) 
	
	pop bx
	ret
;=================================================================	
codesg ends
end start