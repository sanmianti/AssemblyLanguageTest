;实验名称：显示字符串

;应用举例：在屏幕的8行3列，用绿色显示data段中的字符串
assume cs:code, ds:data, ss:stacksg
data segment 
	db 'Welcome to masm!', 0
data ends

stacksg segment
	dw 16 dup (0)
stacksg ends

code segment
	
;=======================程序入口==================================
start:
	mov ax, stacksg
	mov ss, ax
	mov sp, 32
	
	mov dh, 8
	mov dl, 3
	mov cl, 2
	;使用ds:si指向字符串的首地址
	mov ax, data
	mov ds, ax
	mov si, 0
	call show_str
	
	mov ax, 4c00h
	int 21h
;=================================================================
	
;=======================在屏幕指定位置显示字符串==================
;子程序名称：
;	show_str
;子程序功能：
;	在指定位置，用指定的颜色，显示一个用0结束的字符串
;子程序参数:
;	（dh）= 行号（取值范围0~24），
;	（dl）= 列号（取值范围0~79）
;	 (cl) = 颜色，
;	 ds:[si] = 字符串的首地址。
;子程序返回值：
;	无	
show_str:
	
	push ax
	push cx
	push dx
	push es
	push si
	push bp
	
	;使用es:bp指向目标显存首地址
	mov ax, 0b800h
	mov es, ax
	
	;计算bp的初值
	mov ax, 160
	mul dh
	mov dh, 0
	add ax, dx
	add ax, dx
	mov bp, ax
	
copy:
	;复制一个字母
	mov al, ds:[si]
	;判断是否是字符串尾部,此处要用到cx，因为cx已被使用，所以要先备份cx
	mov dx, cx
	mov ch, 0
	mov cl, al
	jcxz ok
	mov cx, dx
	;粘贴一个字母
	mov byte ptr es:[bp],al
	;粘贴字母属性
	mov byte ptr es:[bp+1], cl
	add si, 1
	add bp, 2
	jmp short copy
	
ok: 
	pop bp
	pop si
	pop es
	pop dx
	pop cx
	pop ax
	
	ret
;=================================================================

code ends
end start