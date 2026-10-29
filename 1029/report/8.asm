.386
.model flat, stdcall
option casemap:none

; 윈도우 기본 시스템 라이브러리 자동 링크 (외부 파일 불필요)
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
    ; 테스트 데이터 (팩 십진수는 리틀 엔디안 방식으로 메모리에 저장)
    ; -------------------------------------------------------------

    ; [테스트 1] 4바이트 (8자리 BCD)
    ; ValA1 = 00103245h, ValB1 = 00896755h  ->  합 = 01000000h
    valA1 BYTE 045h, 032h, 010h, 000h
    valB1 BYTE 055h, 067h, 089h, 000h
    sum1  BYTE 4 DUP(0)

    ; [테스트 2] 8바이트 (16자리 BCD)
    ; ValA2 = 1234567890123456h
    ; ValB2 = 8765432109876543h
    valA2 BYTE 056h, 034h, 012h, 090h, 078h, 056h, 034h, 012h
    valB2 BYTE 043h, 065h, 087h, 009h, 021h, 043h, 065h, 087h
    sum2  BYTE 8 DUP(0)

    ; [테스트 3] 16바이트 (32자리 BCD)
    valA3 BYTE 16 DUP(025h)    ; 25252525...25
    valB3 BYTE 16 DUP(035h)    ; 35353535...35  -> 합 = 60606060...60
    sum3  BYTE 16 DUP(0)

    ; 출력용 메시지
    msgHeader BYTE "=== Extended AddPacked Decimal Test ===", 13, 10, 13, 10, 0
    msgT1     BYTE "[Test 1: 4-Byte Packed Decimal]", 13, 10, 0
    msgT2     BYTE "[Test 2: 8-Byte Packed Decimal]", 13, 10, 0
    msgT3     BYTE "[Test 3: 16-Byte Packed Decimal]", 13, 10, 0
    msgPlus   BYTE " + ", 0
    msgEqu    BYTE " = ", 0
    newline   BYTE 13, 10, 0

.code

; ------------------------------------------------------------------
; PrintBuffer: 콘솔 출력 헬퍼 함수
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; PrintBCD: 메모리의 BCD 데이터를 안전하게 문자열로 변환하여 출력
; ------------------------------------------------------------------
PrintBCD PROC pBuf:PTR BYTE, bufLen:DWORD
    LOCAL tempBuf[64]:BYTE     ; 안전한 지역 변수 출력 버퍼
    pushad

    mov esi, pBuf
    add esi, bufLen
    dec esi                    ; MSB (가장 높은 바이트 주소)
    lea edi, tempBuf           ; 임시 저장 버퍼
    mov ecx, bufLen

ConvertLoop:
    push ecx                   ; ECX 레지스터 보존

    mov al, [esi]

    ; 1. 상위 4비트 (High Nibble) 변환
    mov ah, al
    shr ah, 4
    cmp ah, 9
    jbe H_Digit
    add ah, 'A' - 10
    jmp H_Done
H_Digit:
    add ah, '0'
H_Done:

    ; 2. 하위 4비트 (Low Nibble) 변환
    and al, 0Fh
    cmp al, 9
    jbe L_Digit
    add al, 'A' - 10
    jmp L_Done
L_Digit:
    add al, '0'
L_Done:

    ; 버퍼에 저장
    mov [edi], ah
    mov [edi+1], al
    add edi, 2
    dec esi

    pop ecx                    ; ECX 복원
    loop ConvertLoop

    ; 3. 변환 완료된 전체 문자열을 단 한 번의 API 호출로 출력
    mov eax, bufLen
    shl eax, 1                 ; 출력 글자 수 = 바이트 수 * 2
    lea edi, tempBuf
    INVOKE PrintBuffer, edi, eax

    popad
    ret
PrintBCD ENDP

; ------------------------------------------------------------------
; AddPacked
; Receives: ESI = 수1, EDI = 수2, EDX = 합계 저장소, ECX = 바이트 수
; ------------------------------------------------------------------
AddPacked PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    clc                 ; Carry Flag(올림수) 0으로 초기화

AddLoop:
    mov al, [esi]
    adc al, [edi]       ; Carry 포함 덧셈
    daa                 ; BCD 보정
    mov [edx], al       ; 결과 저장

    inc esi             ; 다음 바이트로 이동 (INC는 Carry Flag를 건드리지 않음)
    inc edi
    inc edx
    loop AddLoop

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
AddPacked ENDP

; ------------------------------------------------------------------
; RunTest: 테스트 및 결과 출력 헬퍼 함수
; ------------------------------------------------------------------
RunTest PROC pA:PTR BYTE, pB:PTR BYTE, pS:PTR BYTE, byteLen:DWORD
    pushad

    ; 1. AddPacked 실행
    mov esi, pA
    mov edi, pB
    mov edx, pS
    mov ecx, byteLen
    call AddPacked

    ; 2. 수1 + 수2 = 결과 출력
    INVOKE PrintBCD, pA, byteLen
    INVOKE PrintBuffer, OFFSET msgPlus, 3
    INVOKE PrintBCD, pB, byteLen
    INVOKE PrintBuffer, OFFSET msgEqu, 3
    INVOKE PrintBCD, pS, byteLen
    INVOKE PrintBuffer, OFFSET newline, 2

    popad
    ret
RunTest ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    INVOKE PrintBuffer, OFFSET msgHeader, 41

    ; [테스트 1] 4바이트
    INVOKE PrintBuffer, OFFSET msgT1, 33
    INVOKE RunTest, OFFSET valA1, OFFSET valB1, OFFSET sum1, 4

    ; [테스트 2] 8바이트
    INVOKE PrintBuffer, OFFSET msgT2, 33
    INVOKE RunTest, OFFSET valA2, OFFSET valB2, OFFSET sum2, 8

    ; [테스트 3] 16바이트
    INVOKE PrintBuffer, OFFSET msgT3, 34
    INVOKE RunTest, OFFSET valA3, OFFSET valB3, OFFSET sum3, 16

    INVOKE ExitProcess, 0
main ENDP

END main