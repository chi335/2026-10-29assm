.386
.model flat, stdcall
option casemap:none

; 윈도우 기본 시스템 라이브러리 자동 링크
includelib kernel32.lib

; 윈도우 API 함수 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
    hStdOut DWORD 0
    bytesWritten DWORD 0

    ; -------------------------------------------------------------
    ; 테스트 데이터 (MASM 표준 h 표기법 적용)
    ; -------------------------------------------------------------

    ; 테스트 1: 12바이트 (3 DWORDs)
    ; ValA1 = 0x112233445566778899AABBCC
    ; ValB1 = 0x010101010101010101010101
    valA1 BYTE 0CCh, 0BBh, 0AAh, 099h, 088h, 077h, 066h, 055h, 044h, 033h, 022h, 011h
    valB1 BYTE 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h
    res1  BYTE 12 DUP(0)
    len1  DWORD 12

    ; 테스트 2: 12바이트 (연속 빌림 테스트)
    ; ValA2 = 0x100000000000000000000000
    ; ValB2 = 0x000000000000000000000001
    valA2 BYTE 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 010h
    valB2 BYTE 001h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    res2  BYTE 12 DUP(0)
    len2  DWORD 12

    ; 테스트 3: 16바이트 (4 DWORDs)
    ; ValA3 = 0xAAAAAAAA55555555FFFFFFFF12345678
    ; ValB3 = 0x11111111111111111111111100000001
    valA3 BYTE 078h, 056h, 034h, 012h, 0FFh, 0FFh, 0FFh, 0FFh, 055h, 055h, 055h, 055h, 0AAh, 0AAh, 0AAh, 0AAh
    valB3 BYTE 001h, 000h, 000h, 000h, 011h, 011h, 011h, 011h, 011h, 011h, 011h, 011h, 011h, 011h, 011h, 011h
    res3  BYTE 16 DUP(0)
    len3  DWORD 16

    ; 출력용 문자열
    msgHeader  BYTE "=== Extended Subtraction Test ===", 13, 10, 0
    msgSub     BYTE " - ", 0
    msgEqu     BYTE " = ", 0
    newline    BYTE 13, 10, 0
    hexBuffer  BYTE 2 DUP(0)

.code

; ------------------------------------------------------------------
; PrintBuffer: 콘솔 출력 헬퍼 함수
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; ByteToHex: 1바이트를 2자리 ASCII 16진수 문자(AH, AL)로 변환
; ------------------------------------------------------------------
ByteToHex PROC
    mov ah, al
    shr ah, 4          ; 상위 4비트
    and al, 0Fh        ; 하위 4비트

    ; 상위 비트 문자 변환
    cmp ah, 9
    jbe H1
    add ah, 55         ; 'A' - 10
    jmp H2
H1: add ah, 48         ; '0'
H2:

    ; 하위 비트 문자 변환
    cmp al, 9
    jbe L1
    add al, 55
    jmp L2
L1: add al, 48
L2:
    ret
ByteToHex ENDP

; ------------------------------------------------------------------
; PrintHexBigNum: 메모리 데이터를 MSB부터 역순으로 출력
; ------------------------------------------------------------------
PrintHexBigNum PROC
    pushad
    add esi, ecx
    dec esi             ; MSB 위치로 이동

PrintLoop:
    mov al, [esi]
    call ByteToHex

    mov hexBuffer[0], ah
    mov hexBuffer[1], al
    INVOKE PrintBuffer, OFFSET hexBuffer, 2

    dec esi
    loop PrintLoop

    popad
    ret
PrintHexBigNum ENDP

; ------------------------------------------------------------------
; Extended_Sub 프로시저
; Receives:
;   ESI = 피뺄수 (Minuend, A)
;   EDI = 뺄수 (Subtrahend, B)
;   EBX = 결과 저장 버퍼 (Result)
;   ECX = DWORD 단위 크기
; ------------------------------------------------------------------
Extended_Sub PROC
    pushad
    clc                 ; Carry Flag(차용수) 0으로 초기화

SubLoop:
    mov eax, [esi]
    sbb eax, [edi]      ; EAX = [ESI] - [EDI] - Borrow
    mov [ebx], eax

    pushfd              ; Carry Flag 보존
    add esi, 4          ; 다음 DWORD 이동
    add edi, 4
    add ebx, 4
    popfd               ; Carry Flag 복원

    loop SubLoop

    popad
    ret
Extended_Sub ENDP

; ------------------------------------------------------------------
; RunTest: 테스트 실행 함수
; ------------------------------------------------------------------
RunTest PROC pA:PTR BYTE, pB:PTR BYTE, pR:PTR BYTE, byteLen:DWORD
    pushad

    ; 1. Extended_Sub 호출 준비
    mov esi, pA
    mov edi, pB
    mov ebx, pR
    mov ecx, byteLen
    shr ecx, 2          ; 바이트 길이 / 4 -> DWORD 개수

    call Extended_Sub

    ; 2. 출력 (A - B = Result)
    mov esi, pA
    mov ecx, byteLen
    call PrintHexBigNum

    INVOKE PrintBuffer, OFFSET msgSub, 3

    mov esi, pB
    mov ecx, byteLen
    call PrintHexBigNum

    INVOKE PrintBuffer, OFFSET msgEqu, 3

    mov esi, pR
    mov ecx, byteLen
    call PrintHexBigNum

    INVOKE PrintBuffer, OFFSET newline, 2

    popad
    ret
RunTest ENDP

; ------------------------------------------------------------------
; main 메인 함수
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    INVOKE PrintBuffer, OFFSET msgHeader, 35

    ; 테스트 1 (12바이트)
    INVOKE RunTest, OFFSET valA1, OFFSET valB1, OFFSET res1, len1

    ; 테스트 2 (12바이트)
    INVOKE RunTest, OFFSET valA2, OFFSET valB2, OFFSET res2, len2

    ; 테스트 3 (16바이트)
    INVOKE RunTest, OFFSET valA3, OFFSET valB3, OFFSET res3, len3

    INVOKE ExitProcess, 0
main ENDP

END main