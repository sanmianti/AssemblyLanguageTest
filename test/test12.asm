; 实验 12 编写0号中断的处理程序

assume cs:code 

code segment 

start:
		;安装中断处理程序，其实就是代码字符在内存中复制的过程↓
		mov ax, cs 
		mov ds, ax 
		mov si, offset do0 	;设置ds:si指向源地址
		mov ax, 0 
		mov es, ax 
		mov di, 200h 		;设置es:di指向目的地址
		mov cx, offset do0end - offset do0 ;设置cx为传输长度，即中断处理程序的长度
		cld 				;设置传输方向为正
		rep movsb
		
		;设置中断向量表，其实就是将中断处理程序的入口地址存放在0号中断源所对应的表项中 ↓ 
		mov ax, 0 
		mov es, ax 
		mov word ptr es:[0*4], 200h		;设置中断处理程序入口偏移地址
		mov word ptr es:[0*4+2], 0		;设置中断处理程序入口偏移地址
		
		;除法溢出运算
		mov ax, 1000h
		mov bh, 1 
		div bh 
		
		;验证下面的代码还会继续向下执行吗？如果执行的话屏幕中间会显示字符 ABC
		;结果证明，下面的代码实际上并未执行，CPU在执行完do0后就退出返回到DOS中了，
		;并未继续向下执行，有些不太理解！
		mov ax, 0b800h
		mov es, ax 
		mov di, 13*160 +36*2 ;
		mov byte ptr es:[di], 41h
		mov byte ptr es:[di+2], 42h
		mov byte ptr es:[di+4], 43h
		
		mov ax, 4c00h
		int 21h
		
	do0:jmp short do0start
		db 'overflow!'
		
		;中断处理程序 ↓
	do0start:	mov ax, cs
				mov ds, ax 
				mov si, 202h	;设置ds:si指向字符串
				
				mov ax, 0b800h
				mov es, ax 
				mov di, 12*160 +36*2 ;设置es:di指向显存空间的中间位置
				
				mov cx, 9
			s:	mov al, [si]
				mov es:[di], al 
				mov byte ptr es:[di+1], 11000010b ;为了增加显示效果，显示红底闪烁绿字
				inc si 
				add di, 2
				loop s 
				
				mov ax, 4c00h 
				int 21h 
				
	do0end:		nop
code ends 
end start 