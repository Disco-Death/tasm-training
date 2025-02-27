; ��ਪ⨢� ��������� 㪠�뢠���, ��
; ������� CS �㤥� 㪠�뢠�� �� ᥣ���� ����
; ������� DX - �� ᥣ���� ������
; ������� SS - �� ᥣ���� �⥪�
assume  cs:code,ds:data, ss:stk

; ������� ������
data segment
	mas1    dw  5 dup (?) ;���� ���ᨢ �ᥫ
	mas2    dw  5 dup (?) ;��ன ���ᨢ �ᥫ
	mes1    db  0ah,0dh,'�㬬�: ','$' 			;��砫� ��� ��ப� � �㬬��
	mes2    db  0ah,0dh,'��������: ','$'		;��砫� ��� ��ப� � ࠧ������
	mes3    db  0ah,0dh,'�ந��������: ','$' 	;��砫� ��� ��ப� � �㬬��
	mes4    db  0ah,0dh,'���⭮�: ','$'			;��砫� ��� ��ப� � ����
	e       dw  9h 		;����騩 ������� ��ண� ���ᨢ�
	i       dw  1h 		;����騩 ������� ��ࢮ�� ���ᨢ�
	tmp     db  0  		;�६����� �࠭����
	abz     dw  ' ','$' ;���室 �� ����� ��ப�
data ends
	
; ������� �⥪�
stk segment stack 'stack'
    db  256 dup('*') ;�뤥�塞 256 ����
stk ends  

; ������� ����
code segment 

; ��楤�� ��� ���������� ���ᨢ�� �᫠��
prep proc near
    mov i,1h ;������ ⥪�騬 ���� ������⮬ ��ࢮ�� ���ᨢ� �������
    mov e,9h ;������ ⥪�騬 ���� ������⮬ ��ண� ���ᨢ� �᫮ 9
	; 2 ��ப� ��� �����⮢�� ������
    mov ax,data 
    mov ds,ax      
    xor ax,ax ; ���㫥��� ॣ���� AX
    xor bx,bx ; ���㫥��� ॣ���� BX
    mov SI,0  ; ������ ⥪�饣� ������� ���ᨢ�
    mov CX,5  ; ��᫮ ������⮢ � ����� ���ᨢ��
;��⪠ ��� ���室�
go:
    mov bx,i 		; �����뢠�� � ॣ���� BX ⥪�饥 ��⮢�� �᫮
    mov mas1[si],bx ; � �� ॣ���� BX ��७�ᨬ �� �᫮ �� i-� ������ ��ࢮ�� ���ᨢ�
    mov ax,e 		; �����뢠�� � ॣ���� AX ⥪�饥 ��⮢�� �᫮
    mov mas2[si],ax ; � �� ॣ���� BX ��७�ᨬ �� �᫮ �� i-� ������ ��ண� ���ᨢ�
    inc i 			; �륫�稢��� ⥪�饥 �᫮ (᫥�. �������) ��� ��ࢮ�� ���ᨢ� �� 1
	; � ��� ��� ��ண� ���ᨢ� �㤥� 㢨��稢��� �᫠ �� 2
    inc e
    inc e
	; ���室�� � ��ࠡ�⪥ ᫥���饩 ���� ������⮢ ���� ���ᨢ��
    inc si
    inc si
; ���� SI (⥪�騩 ������) ����� 祬 CX (������ ���ᨢ��), ���室�� � ��⪥ go
LOOP go 
    ret ; �����頥��� �� �㪭樨 

; ��楤�� ��� �㬬�஢���� ������⮢ ���� ���ᨢ�� � ��������묨 �����ᠬ�
prep endp
add_proc proc near
    mov si,0 ; ������ ⥪�饣� ������� ���ᨢ�
    mov cx,5 ; ��᫮ ������⮢ � ����� ���ᨢ��
;��⪠ ��� ���室�
sum:
    mov bx,mas1[si] ; ��७�ᨬ ⥪�騩 ������� ��ࢮ�� ���ᨢ� � ॣ���� BX
    mov ax,mas2[si] ; ��७�ᨬ ⥪�騩 ������� ��ண� ���ᨢ� � ॣ���� AX
    add ax,bx 		; ����襬 � ॣ���� AX �㬬� ॣ���஢ AX � BX, � ����, ⥪�饩 ���� ������⮢
    mov mas1[si],ax ; �����뢠�� ����稢����� �㬬� ⥪��� ������⮢ �� ���� ⥪�饣� ������� ��ࢮ�� ���ᨢ�
    ; ���室�� � ��宦����� �㬬� ᫥���饩 ����
	inc si
    inc si
; ���� SI (⥪�騩 ������) ����� 祬 CX (������ ���ᨢ��), ���室�� � ��⪥ sum
loop sum
    ret ; �����頥��� �� �㪭樨 
add_proc endp

; ��楤�� ��� ���⠭�� ������⮢ ���� ���ᨢ�� � ��������묨 �����ᠬ�
sub_proc proc near
	mov si,0 ; ������ ⥪�饣� ������� ���ᨢ�
	mov cx,5 ; ��᫮ ������⮢ � ����� ���ᨢ��
;��⪠ ��� ���室�
label_sub:
	mov bx,mas1[si] ; ��७�ᨬ ⥪�騩 ������� ��ࢮ�� ���ᨢ� � ॣ���� BX
	mov ax,mas2[si] ; ��७�ᨬ ⥪�騩 ������� ��ண� ���ᨢ� � ॣ���� AX
	sub ax,bx 		; ����襬 � ॣ���� AX ࠧ����� ॣ���஢ AX � BX, � ����, ⥪�饩 ���� ������⮢
	mov mas1[si],ax ; �����뢠�� ����稢����� ࠧ����� ⥪��� ������⮢ �� ���� ⥪�饣� ������� ��ࢮ�� ���ᨢ�
	; ���室�� � ��宦����� �㬬� ᫥���饩 ����
	inc si
	inc si
; ���� SI (⥪�騩 ������) ����� 祬 CX (������ ���ᨢ��), ���室�� � ��⪥ label_sub
loop label_sub
	ret ; �����頥��� �� �㪭樨 
sub_proc endp

; ��楤�� ��� ������� ������⮢ ���� ���ᨢ�� � ��������묨 �����ᠬ�
div_proc proc near
    mov si,0 ; ������ ⥪�饣� ������� ���ᨢ�
    mov cx,5 ; ��᫮ ������⮢ � ����� ���ᨢ��
;��⪠ ��� ���室�
del:
    xor dx,dx 		; ����塞 ॣ���� DX
    mov bx,mas1[si] ; ��७�ᨬ ⥪�騩 ������� ��ࢮ�� ���ᨢ� � ॣ���� BX
    mov ax,mas2[si] ; ��७�ᨬ ⥪�騩 ������� ��ண� ���ᨢ� � ॣ���� AX
    div bl			; ����襬 � ॣ���� AL ��⭮� ॣ���஢ AX � BL, � ����, ⥪�饩 ���� ������⮢
    mov dl,al 		; ��७�� ������� �� ॣ���� AL � ॣ���� DL
    mov mas1[si],dx ; �����뢠�� ����稢襥�� ��⭮� ⥪��� ������⮢ �� ���� ⥪�饣� ������� ��ࢮ�� ���ᨢ�
    ; ���室�� � ��宦����� �㬬� ᫥���饩 ����
	inc si
    inc si
; ���� SI (⥪�騩 ������) ����� 祬 CX (������ ���ᨢ��), ���室�� � ��⪥ del
loop    del
    ret ; �����頥��� �� �㪭樨 
div_proc endp


; ��楤�� ��� ��६������� ������⮢ ���� ���ᨢ�� � ��������묨 �����ᠬ�
mul_proc proc near
	mov si,0 ; ������ ⥪�饣� ������� ���ᨢ�
	mov cx,5 ; ��᫮ ������⮢ � ����� ���ᨢ��
;��⪠ ��� ���室�
label_mul:
	xor dx,dx 		; ����塞 ॣ���� DX
	mov bx,mas1[si] ; ��७�ᨬ ⥪�騩 ������� ��ࢮ�� ���ᨢ� � ॣ���� BX
	mov ax,mas2[si] ; ��७�ᨬ ⥪�騩 ������� ��ண� ���ᨢ� � ॣ���� AX
	mul bl 			; ����襬 � ॣ���� AX �ந�������� ॣ���஢ BL � AL, � ����, ⥪�饩 ���� ������⮢
	mov dx,ax 		; ��७�� ������� �� ॣ���� AX � ॣ���� DX
	mov mas1[si],dx ; �����뢠�� ����稢襥�� �ந�������� ⥪��� ������⮢ �� ���� ⥪�饣� ������� ��ࢮ�� ���ᨢ�
	; ���室�� � ��宦����� �㬬� ᫥���饩 ����
	inc si
	inc si
; ���� SI (⥪�騩 ������) ����� 祬 CX (������ ���ᨢ��), ���室�� � ��⪥ mul
loop label_mul
	ret ; �����頥��� �� �㪭樨 
mul_proc endp

; ��楤�� ��� �뢮�� �ᥫ �� ��ࢮ�� ���ᨢ�, 
; ⠪ ��� ��ॢ�� �ᥫ � ᨬ���� ��� �ᥫ - ��� �����
outp proc near
    mov si,0 ; ������ ⥪�饣� ������� ���ᨢ�
    mov cx,5 ; ��᫮ ������⮢ � ����� ���ᨢ��
; ��⪠ ��� ���室�
show:
    mov ax,mas1[si] ; ��७�ᨬ ⥪�騩 ������� ��ࢮ�� ���ᨢ� � ॣ���� AX
    mov dl,10 ; �������� � ॣ���� DL, �� � ��� �����筠� ��⥬� ��᫥���
	; ����襬 � ॣ���� AL ��⭮� ॣ���஢ AX � DL, 
	; � � AH - ���⮪ �� �������
	; �� ����室���, �⮡� �⤥���� ���� ࠧ�� �� �᫠ ��� �뢮�� �� ������ ᨬ����
    div dl 
    mov tmp,ah ; ��७��� ���⮪ �� ������� � ��६����� temp
    mov dl,al  ; ��७��� ��⭮� �� ॣ���� AL � ॣ���� DL
	; �����稢��� ��⭮� �� �� �����᪮� �᫮, 
	; �⮡� ������� ����� ᨬ���� ASCII ���� 
    add dl,30h 
    mov ah,02h ; ����襬 � ॣ���� AH �����, ��� �뢮�� ASCII-��� ᨬ���� 
    int 21h ; ��뢠�� ���뢠���
    mov dl,tmp
    add dl,30h
    mov ah,02h
    int 21h
    inc si
    inc si
    mov ah,09h
    lea dx,abz
    int 21h
loop show
    ret
outp endp

; ��楤�� ��� �뢮�� �ᥫ �� ��ࢮ�� ���ᨢ�, 
; ⠪ ��� ��ॢ�� �ᥫ � ᨬ���� ��� �ᥫ - ��� �����
outp2 proc near
    mov si,0
    mov cx,5
show2:
    mov ax,mas2[si]
    mov dl,10
    div dl
    mov tmp,ah
    mov dl,al
    add dl,30h
    mov ah,02h
    int 21h
    mov dl,tmp
    add dl,30h
    mov ah,02h
    int 21h
    inc si
    inc si
    mov ah,09h
    lea dx,abz
    int 21h
loop show2
    ret
outp2 endp

; ��砫� �ணࠬ��
begin:
    call prep 	; ������塞 ���ᨢ� �᫠��
    call outp 	; �뢮��� ���� ���ᨢ �� ��࠭
    call outp2 	;�뢮��� ��ன ���ᨢ �� ��࠭�
	
    mov  ah,09h 	; ����뢠�� 9-� ����� (�뢮� ��ப�, 㪠�뢠���� � ॣ���� DX �� ��࠭)
    lea  dx,mes1 	; ���ᨬ ��砫� ᮮ�饭�� � १���⠬� �㬬�஢����
    int  21h 		; ��뢠�� ���뢠��� � �뢮� ⥪��
    call add_proc 	; �㬬��㥬 �������� ���ᨢ��
    call outp 		; �뢮��� १����, �࠭�騩�� � ��ࢮ� ���ᨢ�
    call prep 		; ������ ������㥬 ⠪�� �� ���� ���ᨢ
	
    mov ah,09h 		; ����뢠�� 9-� ����� (�뢮� ��ப�, 㪠�뢠���� � ॣ���� DX �� ��࠭)
    lea  dx,mes2 	; ���ᨬ ��砫� ᮮ�饭�� � १���⠬� ���⠭��
    int   21h 		; ��뢠�� ���뢠��� � �뢮� ⥪��
    call sub_proc 	; ���⠥� �������� ���ᨢ��
    call outp 		; �뢮��� १����, �࠭�騩�� � ��ࢮ� ���ᨢ�
    call prep 		; ������ ������㥬 ⠪�� �� ���� ���ᨢ
	
    mov  ah,09h 	; ����뢠�� 9-� ����� (�뢮� ��ப�, 㪠�뢠���� � ॣ���� DX �� ��࠭)
    lea  dx,mes3 	; ���ᨬ ��砫� ᮮ�饭�� � १���⠬� ��६�������
    int   21h 		; ��뢠�� ���뢠��� � �뢮� ⥪��
	call mul_proc 	; ��६������ �������� ���ᨢ��
	call outp 		; �뢮��� १����, �࠭�騩�� � ��ࢮ� ���ᨢ�
	call prep 		; ������ ������㥬 ⠪�� �� ���� ���ᨢ
	
	mov ah,09h 		; ����뢠�� 9-� ����� (�뢮� ��ப�, 㪠�뢠���� � ॣ���� DX �� ��࠭)
	lea  dx,mes4 	; ���ᨬ ��砫� ᮮ�饭�� � १���⠬� �������
	int  21h 		; ��뢠�� ���뢠��� � �뢮� ⥪��
	call div_proc 	; ����� �������� ���ᨢ��
	call outp 		; �뢮��� १����, �࠭�騩�� � ��ࢮ� ���ᨢ�
	
    mov  ax,4c00h  	; ����뢠�� ����� ��� ���४���� �४�饭�� �ணࠬ��
    int  21h 		; ���뢠�� �ணࠬ��  
code ends         

end begin ; ����� �ணࠬ��