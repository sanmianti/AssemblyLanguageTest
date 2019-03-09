;实验名称： 数值显示

assume cs:code
;声明10个字节的内存空间，用以存放字符串ASCII码
data segment
	db 32 dup (0)
data ends

;声明一个栈空间，用以临时备份数据
stack segment
	dw 16 dup (0)
stack ends

code segment
;============================程序入口=============================
start: 
	;初始化运行环境
	
	;初始化栈
	mov bx, stack
	mov ss, bx
	mov sp, 16
	
	;声明参数，并调用子程序dtoc
	mov ax, 12600
	mov bx, data
	mov ds, bx
	mov si, 0
	call dtoc
	
	;声明参数，并调用子程序show_str
	mov dh, 8
	mov dl, 3
	mov cl, 2
	mov ax, data
	mov ds, ax
	mov si, 0
	call show_str
	
	mov ax, 4c00h
	int 21h
;=================================================================
	
;=======================十进制数据显示子程序======================

;子程序描述
;名称：
;	dtoc
;功能：
;	将word类型数据转变为表示十进制数的字符串
;参数:
;	（ax）= word型数据
;	 ds:[si]=指向字符串的首地址
;返回：
;	无	
dtoc:
	;字符串用0表示结束
	mov bx, 0
	push bx
step1:	
	;声明参数，并调用子程序divdw
	mov dx, 0
	mov cx, 10
	call divdw
	
	;余数+30h构建成ASCII码，然后入栈暂存
	add cx, 30H
	push cx

	;判断商是否为0
	mov cx, ax
	jcxz step2
	jmp short step1
	
step2:
	pop cx
	mov ds:[si], cl
	jcxz step3
	inc si
	jmp short step2
step3:
	ret
;=================================================================

;======================非溢出除法运算子程序=======================
;子程序描述
;名称：
;	divdw
;功能：
;	进行不会产生溢出的除法运算，被除数为双字（dword）型，
;	除数为单字（word）型，商为双字型，余数为单字型。
;参数：	
;	（dx） = 被除数的高16位
;	（ax） = 被除数的低16位
;	（cx） = 除数
;返回：	
;	（dx） = 商的高16位
;	（ax） = 商的低16位
;	（cx） = 余数
;公式：
;	 X/N = int(H/N)*65536 + [rem(H/N)*65536 + L]/N。
divdw:
	
	mov bx, ax	;(bx) = L
	mov ax, dx	;(ax) = H
	mov dx, 0	;(dx) = 0
	div cx		;(dx) = 0,(ax) = H, (cx) = N
	push ax		;(ax) = int(H/N)
	
	mov ax, bx	;(bx) = L
	div cx		;(dx) = rem(H/N),(ax) = L, (cx) = N
	mov cx, dx	;(dx) = rem{[rem(H/N)*65536 + L]/N}, (ax) = int{[rem(H/N)*65536 + L]/N}
	pop dx		;(ss:sp) = int(H/N) 
	
	ret
;=================================================================

;====================字符串展示子程序=============================
;子程序名称：
;	show_str
;子程序功能：
;	在指定位置，用指定的颜色，显示一个用0结束的字符串
;子程序参数：
;	（dh）= 行号（取值范围0~24）
;	（dl）= 列号（取值范围0~79）
;	（cl） = 颜色，ds:si指向字符串的首地址。
;子程序返回值：
;	 无	
show_str:
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
	ret
;=================================================================

code ends
end start