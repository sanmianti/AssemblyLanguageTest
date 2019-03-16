;实验7 寻址方式在结构化数据访问中的应用
;
assume cs:codesg, ds:datasg, ss:table

datasg segment
	;定义年份,占84个字节
	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982'
	db '1983', '1984', '1985', '1986', '1987', '1988', '1989', '1990'
	db '1991', '1992', '1993', '1994', '1995'
	;定义收入, 占84个字节
	dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486
	dd 50065, 97479, 140417, 197514, 345980, 590827, 803530, 1183000
	dd 1843000, 2759000, 3753000, 4649000, 5937000
	;定义雇员人数，占42个字节
	dw 3, 7, 9, 13, 28, 38, 130, 220
	dw 476, 778, 1001, 1442, 2258, 2793, 4037,5635
	dw 8226, 11542, 14430, 15257, 17800
datasg ends

table segment
	;定义21行的一个表格，每行16个字节，共占246个字节
	db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start:
	;第一步 设置 
	;ds指向datasg,bx用于定位datasg数组 
	;ss指向table, bp用于定位table行

	mov ax, datasg
	mov ds, ax
	mov bx, 0
	mov ax, table
	mov ss, ax
	mov bp, 0

	;复制年份和空格
	mov cx, 21	;循环执行次数
	mov si, 0	;定位年份
	mov di, 0	;定位收入

loop1:

	;使用ds:[bx+0+si]定位年份
	mov ax, ds:[bx+si]		;复制年份前两个字节
	mov ss:[bp+0], ax		;粘贴年份前两个字节
	add si, 2				;年份下标后移两位
	mov ax, [bx+si]			;复制年份后两个字节
	mov ss:[bp+2], ax		;粘贴年份后两个字节
	mov byte ptr [bp+4], ' ';粘贴一个空格
	add si, 2
	
	;使用ds:[bx+84+di]定位收入
	mov ax, [bx+84+di]		;复制收入前两个字节
	mov ss:[bp+5], ax		;粘贴收入前两个字节
	add di, 2				;收入索引+2
	mov ax, [bx+84+di]		;复制收入后两个字节
	mov ss:[bp+7],ax		;粘贴收入后两个字节
	mov byte ptr [bp+9], ' ';复制空格
	add di, 2				;收入索引+2

	add bp, 16
	loop loop1

	mov cx, 21
	mov si, 0
	mov bp, 0
loop2:
	;使用ds:[bx+84+84+si]定位雇员人数
	mov ax, [bx+84+84+si]	;复制雇员数量
	mov [bp+10], ax			;粘贴雇员人数
	add si, 2				;雇员人数索引+2
	mov byte ptr [bp+12],' ';复制空格

	mov dx, [bp+7]			;收入高16位
	mov ax, [bp+5]			;收入低16位
	div word ptr [bp+10]	;除以人数
	mov [bp+13], ax			;粘贴商
	mov byte ptr [bp+15],' ';复制空格


	add bp, 16
	loop loop2


	mov ax, 4c00h
	int 21h
	
codesg ends
end start