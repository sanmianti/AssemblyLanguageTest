;课程设计1
;将实验7中的Power idea 公司的数据按照图10.2所示的格式在屏幕上显示出来
;
;思路
;寻址方式
;DS:[0]:[SI]指向原始数据年份
;DS:[84]:[DI]指向原始数据收入
;DS:[84+84][BX]指向原始数据雇员人数
;DS:[0+84+84+42]指向临时护具存储区
;ES:[BP]指向目标表格每行首地址
;
;
;年份的显示
;年份原始数据即是字符本身的ASCII码，不用做变换，直接复制到显存即可。
;DS:[0]:[0] → ES:[0][0] ;复制'19'
;DS:[0]:[2] → ES:[0][2] ;复制'75'
;
;收入的显示
;收入数每位要先转换为对应数符的ASCII码，然后在复制到显存
;
;
;雇员人数的显示
;雇员人数每位同样要先转换为对应数符的ASCII吗，然后在复制到显存
;
;人均收入的显示
;人均收入原始数据未给出。所以要通过收入/人数的方式计算人均收入。
;计算人均收入后将收入每位转换为数符对应的ASCII码，然后复制到显存。
;
assume cs:codesg, ds:datasg, ss:stacksg

;原始数据存储区
datasg segment
	;Power idea公司原始数据
	;定义年份,占84个字节
	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982'
	db '1983', '1984', '1985', '1986', '1987', '1988', '1989', '1990'
	db '1991', '1992', '1993', '1994', '1995'
	;定义收入, 双字型，占84个字节
	dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486
	dd 50065, 97479, 140417, 197514, 345980, 590827, 803530, 1183000
	dd 1843000, 2759000, 3753000, 4649000, 5937000
	;定义雇员人数，单字型，占42个字节
	dw 3, 7, 9, 13, 28, 38, 130, 220
	dw 476, 778, 1001, 1442, 2258, 2793, 4037,5635
	dw 8226, 11542, 14430, 15257, 17800
	;额外开辟16个字节的临时数据存储区
	dw 8 dup (0)
datasg ends

;栈空间
stacksg segment
	dw 32 dup (0)
stacksg ends

codesg segment
start:
	;初始化原始数据区
	mov ax, datasg
	mov ds, ax
	
	;初始化栈区
	mov ax, stacksg
	mov ss, ax
	mov sp, 64
	
	mov cx, 21					;循环次数
	mov al, 2					;行号
	mov si, 0					;年份索引号
	mov di, 84					;收入索引号
	mov bx, [84+84]				;雇员人数索引号
loop1:
	
	call short show_year
	call short show_income
	call short show_people_num
	call short show_average_income	
 	
	add si, 4					;年份索引+4,指向下一年
	add di, 4					;收入索引+4，指向下一年收入
	add bx, 2					;人数索引+2，指向下一年雇员人数
	inc al						;行号+1，指向下一行
	
	loop loop1
	
	mov ax, 4c00h
	int 21h
	

;=======================计算人均收入并展示========================
;子程序描述
;名称：
;	show_average_income
;功能：
;	根据历年总收入及雇员人数计算平均收入，并显示在屏幕上。
;	因为在主函数中loop循环对IP的修改限制在 -128~127之间。为了避免该限制
;	将这一部分代码构造一个子程序。
;参数：
;	（di）= 总收入索引
;	（bx）= 雇员人数索引
;	（al）= 结果展示行号
;返回值：
;	无
show_average_income:
	
	push dx
	push ax
	push cx
	push si
	
	;计算人均收入并展示
	;计算人均收入
	push ax						;备份ax
	mov dx, ds:[di+2]			;收入高16位
	mov ax, ds:[di]				;收入低16位
	mov cx, ds:[bx]				;人数
	call short divdw			;除法运算，计算人均收入
	
	;将人均收入数符转换为字符
	mov si, 210
	call short dtoc
	;显示人均收入
	pop ax
	mov dh, al
	mov dl, 25
	mov cl, 2
	mov si, 210
	call short show_str
	
	pop si
	pop cx
	pop ax
	pop dx
	
	ret
;=================================================================
	
;=======================展示雇员人数==============================
;子程序描述
;名称：
;	show_people_num
;功能：
;	展示雇员人数
;参数：
;	（si）= 雇员人数索引
;返回值：
;	无
show_people_num:

	;雇员人数数符转换为对应十进制字符
	push dx
	push ax
	push si
	
	mov dx, 0
	mov ax, ds:[bx]
	mov si, 210
	call short dtoc
	pop si
	pop ax
	pop dx
	;显示雇员人数
	push dx
	push cx
	push si
	mov dh, al
	mov dl, 18
	mov cl, 2
	mov si, 210
	call short show_str
	
	pop si
	pop cx
	pop dx
	
	
	ret
;=================================================================	
;=======================展示收入==================================
;子程序描述
;名称：
;	show_income
;功能：
;	展示收入
;参数：
;	（di）= 收入索引
;返回值：
;	无
show_income:
				
	;将十进制收入数符转换为字符，存入ds:[si]处
	push ax
	push dx
	push si
	mov ax, ds:[di]
	mov dx, ds:[di+2]
	mov si, 210
	call short dtoc	
	pop si
	pop dx
	pop ax
	;显示字符串
	push dx
	push cx
	push si
	mov dh, al					;行号
	mov dl, 7					;列号
	mov cl, 2					;字符串颜色
	mov si, 210					;字符串首地址
	call short show_str
	pop si
	pop cx
	pop dx
	
	ret
;=================================================================	

;=======================展示年份==================================
;子程序描述
;名称：
;	show_year
;功能：
;	展示年份列表
;参数：
;	（si）= 年份索引
;返回值：
;	无
show_year:
	
	push si						;备份si
	push cx						;备份cx
	push dx
	push bx
	
	mov bx, ds:[si]				;年份前两个字节
	mov ds:[84+84+42], bx
	mov bx, ds:[si+2]			;年份后两个字节
	mov ds:[84+84+42].[2], bx
	mov byte ptr ds:[84+84+42].[4], 0
	
	mov dh, al					;行号
	mov dl, 0					;列号
	mov cl, 2					;字符串颜色
	mov si, 210					;字符串首地址
	call short show_str
	
	pop bx
	pop dx
	pop cx
	pop si
	
	ret
;=================================================================	
	
;=======================十进制数符转换为字符串====================

;子程序描述
;名称：
;	dtoc
;功能：
;	将word类型数据转变为表示十进制数的字符串
;参数:
;	（dx）= word型数据高16位
;	（ax）= word型数据低16位
;	（ds:[si]) = 字符串的首地址
;返回：
;	无	
dtoc:

	;备份寄存器
	push cx
	push si
	push bx
	
	;字符串用0表示结束
	mov bx, 0
	push bx
step1:	
	;声明参数，并调用子程序divdw
	mov cx, 10
	call divdw
	
	;余数+30h构建成ASCII码，然后入栈暂存
	add cx, 30H
	push cx

	;判断商是否为0
	mov bx, 0
	add bx, ax
	add bx, dx
	mov cx, bx
	jcxz step2
	jmp short step1
	
step2:
	pop cx
	mov ds:[si], cl
	jcxz step3
	inc si
	jmp short step2
step3:
	pop bx
	pop si
	pop cx
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
;	（cl）= 颜色
;	 ds:[si]= 字符串的首地址。
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
;	X/N = int(H/N)*65536 + [rem(H/N)*65536 + L]/N。
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