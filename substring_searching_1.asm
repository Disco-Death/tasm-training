assume  cs:code, ds:data, ss:stk

data segment
    lwString    DW    ?
    lwSubstr    DW    ?
    sdInfo      DB    "Searches substring in string; enter empty string to exit"
    sdCrLf      DB    10, 13, "$"
    sdString    DB    " string: $"
    sdSubStr    DB    " substr: $"
    sdNotFound  DB    " not found", 10, 13, "$"
    sdOffset    DB    " offset: $"
    PromptLen   EQU   9
    BufLen      EQU   80 - PromptLen
    kbBufStr    LABEL Byte
    chBufStr    EQU   kbBufStr + 2
    kbBufSub    EQU   chBufStr + BufLen
    chBufSub    EQU   kbBufSub + 2
data ends

stk  segment  stack 'stack'
    db  256 dup(?)
stk  ends

code segment
    begin:
    mov ax, data
    mov ds, ax
    
    LEA   DX, sdInfo
    CALL  showSd
STR_LOOP:

; Input string
      LEA   BX, kbBufStr
      LEA   DX, sdString
      CALL  inpSd
      JZ    EXIT
      MOV   lwString, AX
      
; Input substring
      LEA   BX, kbBufSub
      LEA   DX, sdSubStr
      CALL  inpSd
      JZ    STR_LOOP
      MOV   lwSubstr, AX
;
      LEA   BX, chBufStr
      MOV   DX, lwString
SUB_LOOP:
      CMP   DX, lwSubstr
      JNC   DO_CMP
      LEA   DX, sdNotFound
      CALL  showSd
      JMP   STR_LOOP
DO_CMP:
      MOV   DI, BX
      LEA   SI, chBufSub
      MOV   CX, lwSubstr
      REPE CMPSB
      JE    SUB_FOUND
      DEC   DX
      INC   BX
      JMP   SUB_LOOP
SUB_FOUND:
; Substring found
      LEA   DX, sdOffset
      CALL  showSd
; Display Result
      MOV   AX, DI
      SUB   AX, Offset chBufStr
      SUB   AX, lwSubstr
      AAM
      MOV   CX, AX
      TEST  CH, CH
      JZ    LOW_DIGIT
      MOV   DL, CH
      CALL  showDigit
LOW_DIGIT:
      MOV   DL, CL
      CALL  showDigit
      LEA   DX, sdCrLf
      CALL  showSd
      JMP   STR_LOOP
EXIT:
      RET
;
showSd:
; Input: DX = Message Address
      MOV   AH, 9
      INT   21h
      RET
;
showDigit:
; Input: DL = Digit in range 0-9
      ADD   DL, "0"
      MOV   AH, 2
      INT   21h
      RET
;
inpSd:
; Input:  DX = Message Address
;         BX = Buffer Address
; Output: AX = String Length
      CALL  showSd
      MOV   [BX], Byte Ptr BufLen
      MOV   DX, BX
      MOV   AH, 0Ah
      INT   21h
      LEA   DX, sdCrLf
      CALL  showSd
      XOR   AH, AH
      MOV   AL, [BX+1]  ; String length
      TEST  AX, AX
      RET
        
      mov ax,4c00h
      int 21h
code ends

end  begin