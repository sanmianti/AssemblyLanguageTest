;实验9 根据材料编程
;
;编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串'welcome to masm!'
;
;
assume cs:codesg, ds:datasg

datasg segment
		db 'welcome to masm!'	;16个字节
datasg ends

codesg segment
	
	start:
			mov ax, datasg				;源数据段地址
			mov ds, ax
			
			mov ax, 0B800H				;目的数据段地址
			mov es, ax			
			
			mov cx, 16
			mov si, 0
			mov bx, 0140H				;用于定位行，从第三行开始
			mov di, 0					;用于定位列
			
		s:	mov al, ds:[si]								;复制一个字节
			mov es:[bx][di], al 						;第一行，偶数列
			mov es:160[bx][di], al						;第二行，偶数列
			mov es:320[bx][di], al 						;第三行，偶数列
			mov byte ptr es:[bx][di+1], 00000010B		;第一行，奇数列
			mov byte ptr es:160[bx][di+1], 00100100B	;第二行，奇数列
			mov byte ptr es:320[bx][di+1], 01110001B	;第三行，奇数列
			inc si
			add bx, 2
			loop s
			
			mov ax, 4c00h
			int 21h
	
codesg ends
end start