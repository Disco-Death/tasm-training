assume	cs:code, ds:data, ss:stk
;Формирование сжатой строки символов. Сжатие заключается в удалении
;пробелов из исходной строки при просмотре ее слева направо.
data segment						;начало сегмента данных

	nachstrok	db	'  He l   lo ...w orl   d!$';
	;
	;nachstrok db 128 dup(?)
	;
	konechnstrok	db	255 dup (' ')	;Результирующая строка
	newstrok	db	0ah,0dh,'$'		;переход на новую строку
	indnach	db	0					;Счётчик положения символа nachstrok 
	indkonechn	db	0				;Счётчик положения символа konechnstrok  
data ends							;конец сегмента данных

code segment			;начало сегмента команд

	delSpace proc near
		xor ax,ax			;Обнуляем ax
		mov indnach,al		;Обнуляем indnach
		mov indkonechn,al	;Обнуляем indkonechn
		mov si,ax			;Обнуляем si - строка-источник
		
	itNext:
		xor ax,ax			;Обнуляем ax
		mov al,indnach		;al:indnach
		mov si,ax			;si:indnach
		
		mov dl,nachstrok[si];dl:nachstrok[si]
		cmp dl,'$'			;dl = '$'? конец строки
		je return			;jump return if equal
		
		mov al,indnach		;al:indnach
		inc al				;++al без CF 
		mov indnach,al		;indnach:al
		
		cmp dl,' '			;dl = ' ';? пробел
		je itNext			;jump inNext if equal
		
		xor ax,ax			;Обнуляем ax
		mov al,indkonechn	;al:indkonechn 
		mov si,ax			;si:indkonechn
		
		mov konechnstrok[si],dl	;konechnstrok[si]:dl
		
		mov al,indkonechn		;al:indkonechn
		inc al				;++al без CФа
		mov indkonechn,al		;indnach:al
		jmp itNext			;бзсл прыгаем на itNext
	
	return:
		xor ax,ax			;Обнуляем ax
		mov al,indkonechn	;al:indkonechn
		mov si,ax			;si:indkonechn
		
		mov konechnstrok[si],'$'	;konechnstrok[si]:'$'
			
		ret					;return to begin
	delSpace endp

	begin:				;метка begin, точка входа в программу
		mov ax,data		;записываем в регистр ax начало сегмента данных
		mov ds,ax		;записываем в ds начало сегмента данных
		
		;
		;lea	dx, nachstrok
		;mov	ah, 9
		;int	21h
		;
		
		mov ah,09h
		lea dx,nachstrok;берём адрес строки nachstrok
		int  21h		;вывод строки nachstrok
		
		call delSpace
		
		mov ah,09h
		lea dx,newstrok	;берём адрес строки newstrok
		int 21h			;переход на другую строку
		
		mov ah,09h
		lea dx,konechnstrok	;берём адрес строки konechnstrok - готовая последняя
	
		
		mov ax,4c00h	;Функция 4C00h - выход из программы.
		int 21h			;Вызов DOS
code ends				;конец сегмента команд
	

stk  segment  stack		;начало сегмента кода стека
	db  256 dup(0)		;Резервируем 256 байт для стека 
stk  ends				;конец сегмента кода стека


end  begin				;конец программы, запуск точки входа

