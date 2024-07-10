assume  cs:code, ds:data, ss:stk

data segment
    string          db  '2344435$'
    string_size     EQU $ - string
    cymbols         db  '43$'
	cymbols_size	EQU $ - cymbols
    curr_index_cymb db  0
    find_index      db  0
    NEWLINE         db  10,13,'$'
    NOT_FOUND       db 'NO RESULT$'
data ends

stk  segment  stack 'stack'
    db  256 dup(?)
stk  ends

code segment

    Find proc near
        
		lea dx, cymbols
		cld
		mov al, cymbols
		xor cx, cx
		mov cx, string_size
		lea di, string

	cycl:
		repne scasb
		je found
		
	nofound:
		mov ah, 09h
        lea dx, NOT_FOUND
        int 21h
		jmp exit
		
	found:
		push di
		lea si, cymbols
		push cx
		xor cx, cx
		mov cx, cymbols_size
		dec di
		repe cmpsb
		je match
	
	mismatch:
		dec di
		pop cx
		pop di
		cmp cx, 0
		jne cycl
		
		mov ah, 09h
		lea dx, NOT_FOUND
		int 21h
		jmp exit
		
	match:
		pop cx
		xor ax, ax
		mov al, string_size
		sub ax, cx
		
		mov bx, 10
		xor cx, cx
		std
		
	begin1:
		div bl
		inc cx
		mov dl, al
		add ah, 30h
		mov al, ah
		push bx
		mov bl, ah
		mov al, bl
		pop bx
		xor ah, ah
		stosb
		mov al, dl
		cmp al, 0
		jne begin1
		
		cld
		mov si, di
		inc si
		mov ah, 02h
	
	cycl1:
		lodsb
		mov dl, al
		int 21h
		loop cycl1
		
	exit:
        ret                 
        
    Find endp

    begin:
        mov ax, data
        mov ds, ax
		mov es, ax
        
        mov ah, 09h
        lea dx, string
        int 21h
        
        mov ah, 09h
        lea dx, NEWLINE  
        int 21h         
        
        mov ah, 09h
        lea dx, cymbols
        int 21h
        
        mov ah, 09h
        lea dx, NEWLINE
        int 21h
     
        call Find
        
        mov ax,4c00h
        int 21h
code ends

end  begin