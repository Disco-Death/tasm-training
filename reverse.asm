assume  cs:code, ds:data, ss:stk

data segment
    string          db  '123456789', '$'
    string_size     equ $ - string
	new_string		db	128	dup	(?)
	new_string_size	equ $ - new_string
	ENDSTRING		db	'$'
    NEWLINE         db  10,13,'$'
data ends

stk  segment  stack 'stack'
    db  256 dup(?)
stk  ends

code segment
    Reverse proc near
Next_cymb:
		xor ax, ax
		lea si, string
		mov cx, string_size
		cld
rep1:
		lodsb
		push ax
		loop rep1
		
		lea di, new_string
		mov cx, string_size
rep2:
		pop ax
		stosb
		loop rep2
		
		mov al, '$'
		stosb
		
        ret
    Reverse endp

begin:
        mov ax, data
        mov ds, ax
        
        mov ah, 09h
        lea dx, string
        int 21h
        
        mov ah, 09h
        lea dx, NEWLINE  
        int 21h
		
        call Reverse
        
        mov ah, 09h
        lea dx, new_string
        int 21h
		
        mov ah, 09h
        lea dx, string 
        int 21h
        
        mov ah, 09h
        lea dx, NEWLINE
        int 21h
        
        mov ax,4c00h
        int 21h
code ends

end  begin