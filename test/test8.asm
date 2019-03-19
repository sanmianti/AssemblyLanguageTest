;实验8 分析一个奇怪的程序
;
;分析下面的程序，在运行前思考：这个程序可以正确返回吗？
;运行后思考：为什么是这种结果？
;
;解析：程序可以正确返回。
;jmp short指令是根据转移目的地址和转移起始之间的位移来进行的。
;jmp short s1 转换为机器指令的16进制表示形式为：EBF6。F6为8位位移
;的补码表示形式。当程序执行至标号s处时，根据jmp short 指令的定义 ：
;（IP）= （IP）+8位位移。可以算出，IP = 0。
;
;
assume cs:codesg

codesg segment 
			
			mov ax, 4c00h
			int 21h
			
	start: 	mov ax, 0
		s:	nop
			nop
			
			mov di, offset s 
			mov si, offset s2
			mov ax, cs:[si]
			mov cs:[di], ax 
			
		s0:	jmp short s 
			
		s1:	mov ax, 0
			int 21h
			mov ax, 0
		
		s2:	jmp short s1
			nop
			
codesg ends
end start