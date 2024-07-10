assume	cs:code, ds:data, ss:stk

;Номер позиции, 
;с которой начинается первое слева вхождение
;заданной конфигурации символов в исходную строку.

data segment						;начало сегмента данных
	string			db	'Hello World!', '$'
	string_size		EQU $ - string
	cymbols     	db	'dao', '$'
	curr_index_str	db	0
	curr_index_cymb	db	0
	find_index		db	1
	NEWLINE			db	10,13,'$'		;переход на новую строку
	NOT_FOUND		db 'В данной строке нет такого символа', '$'
data ends							;конец сегмента данных

stk  segment  stack 'stack'		;начало сегмента кода стека
	db  256 dup(?)		;Резервируем 256 байт для стека 
stk  ends				;конец сегмента кода стека

code segment			;начало сегмента команд

	Find proc near
		xor si, si			;Обнуляем si - строка-источник
		cld
		
	Next_cymb:
		xor ax, ax
		mov al, curr_index_cymb
		mov si, ax
		inc al
		mov curr_index_cymb, al
		mov dl, cymbols[si]
		cmp dl, '$'
		je return
		
	Next_in_str:
		mov al, dl
		mov cx, cymbols_size
		lea di, string
		repne scasb
		jnz Next_cymb
		mov al, 0
		mov find_index, di
	
	return:			
		ret					
		
	delSpace endp
	
	OutInt_AX proc
		mov ax, find_index
		cmp ax, 0
		je result
		
		mov ah, 09h
		lea dx, NOT_FOUND
		int 21h
		jump return
		
	result:
		aam
		add ax,3030h 
		mov dl,ah
		mov dh,al
		mov ah,02
		int 21h
		mov dl,dh
		int 21h
	
	return:
		ret
		
	OutInt endp

	begin:				;метка begin, точка входа в программу
		mov ax, data	;записываем в регистр ax начало сегмента данных
		mov ds, ax		;записываем в ds начало сегмента данных
		
		mov ah, 09h
		lea dx, string	;берём адрес строки nachstrok
		int 21h			;вывод строки nachstrok
		
		mov ah, 09h
		lea dx, cymbols	;берём адрес строки newstrok
		int 21h			;переход на другую строку
		
		call Find
		
		call OutInt_AX
		
		mov ax,4c00h	;Функция 4C00h - выход из программы.
		int 21h			;Вызов DOS
code ends				;конец сегмента команд

end  begin				;конец программы, запуск точки входа