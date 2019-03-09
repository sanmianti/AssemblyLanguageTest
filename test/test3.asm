;实验3 编程、编译、连接、跟踪
;===========================================================
;（1）将下面的程序保存为t1.asm文件，将其生成可执行文件t1.exe
assume cs:codesg

codesg segment 

	mov ax, 2000H
	mov ss, ax
	mov sp, 0
	add sp, 10
	pop ax
	pop bx
	push ax
	push bx 
	pop ax 
	pop bx

	mov ax, 4c00h	
	int 21h
codesg ends
end

;===========================================================
;（2）用Debug跟踪t1.exe的执行过程，写出每一步执行后，相关寄存器
;中的内容和栈顶的内容。
;
;初始值：
;AX=FFFF BX=0000 CX=0016 DS=075A CS=076A IP=0000 SS=0769 SP=0000
;mov ax, 2000
;AX=2000 BX=0000 CX=0016 DS=075A CS=076A IP=0003 SS=0769 SP=0000
;mov ss, ax
;mov sp, 0
;AX=2000 BX=0000 CX=0016 DS=075A CS=076A IP=0008 SS=2000 SP=0000
;add sp, 10
;AX=2000 BX=0000 CX=0016 DS=075A CS=076A IP=000B SS=2000 SP=000A
;pop ax
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=000C SS=2000 SP=000C
;pop bx
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=000D SS=2000 SP=000E
;push ax 
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=000E SS=2000 SP=000C
;push bx 
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=000F SS=2000 SP=000A
;pop ax
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=0010 SS=2000 SP=000C
;pop bx 
;AX=0000 BX=0000 CX=0016 DS=075A CS=076A IP=0011 SS=2000 SP=000E
;mov ax, 4C00
;AX=4C00 BX=0000 CX=0016 DS=075A CS=076A IP=0014 SS=2000 SP=000E
;===========================================================
;（3）PSP的头两个字节是CD 20，用Debug加载t1.exe，查看PSP的内容。
;
;075A:0000 CD 20 FF 9F 00 EA FF FF-AD DE 4F 03 A3 01 8A 03
;...
;...
;===========================================================