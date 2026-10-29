.386
.model flat, stdcall
option casemap:none

; 윈도우 기본 시스템 라이브러리 자동 링크 (별도 설정 불필요)
includelib kernel32.lib

; 윈도우 API 함수 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
    hStdOut DWORD 0
    bytesWritten DWORD 0

    ; 테스트 1 (15자리, 소수점 위치 5)
    DECIMAL_OFFSET1 = 5
    decimal_one     BYTE "100123456789765"
    len1            DWORD LENGTHOF decimal_one

    ; 테스트 2 (8자리, 소수점 위치 2)
    DECIMAL_OFFSET2 = 2
    decimal_two     BYTE "12345678"
    len2            DWORD LENGTHOF decimal_two

    ; 테스트 3 (10자리, 소수점 위치 4)
    DECIMAL_OFFSET3 = 4
    decimal_three   BYTE "9876543210"
    len3            DWORD LENGTHOF decimal_three

    ; 출력용 문자
    dotChar BYTE "."
    newline BYTE 13, 10    ; 줄바꿈 (CR LF)

    msg1 BYTE "Test 1 Output: "
    lenMsg1 = $ - msg1
    msg2 BYTE "Test 2 Output: "
    lenMsg2 = $ - msg2
    msg3 BYTE "Test 3 Output: "
    lenMsg3 = $ - msg3

.code

; ------------------------------------------------------------------
; PrintBuffer (콘솔 출력 헬퍼 함수)
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; WriteScaled 프로시저
; Receives: EDX = 문자열 주소, ECX = 전체 길이, EBX = 소수점 위치
; ------------------------------------------------------------------
WriteScaled PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, edx        ; ESI = 문자열 시작 주소

    ; 정수부 길이 = 전체 길이(ECX) - 소수점 위치(EBX)
    mov eax, ecx
    sub eax, ebx        ; EAX = 정수부 글자 수

    ; 1. 정수부 출력
    push eax
    INVOKE PrintBuffer, esi, eax
    pop eax

    ; 2. 소수부 위치 계산 (ESI + 정수부 길이)
    add esi, eax

    ; 3. 소수점('.') 출력
    INVOKE PrintBuffer, OFFSET dotChar, 1

    ; 4. 소수부 출력 (길이 = EBX)
    INVOKE PrintBuffer, esi, ebx

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
WriteScaled ENDP

; ------------------------------------------------------------------
; 메인 진입점 (main)
; ------------------------------------------------------------------
main PROC
    ; 콘솔 출력 핸들 취득
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; --- 테스트 1 ---
    INVOKE PrintBuffer, OFFSET msg1, lenMsg1
    mov edx, OFFSET decimal_one
    mov ecx, len1
    mov ebx, DECIMAL_OFFSET1
    call WriteScaled
    INVOKE PrintBuffer, OFFSET newline, 2

    ; --- 테스트 2 ---
    INVOKE PrintBuffer, OFFSET msg2, lenMsg2
    mov edx, OFFSET decimal_two
    mov ecx, len2
    mov ebx, DECIMAL_OFFSET2
    call WriteScaled
    INVOKE PrintBuffer, OFFSET newline, 2

    ; --- 테스트 3 ---
    INVOKE PrintBuffer, OFFSET msg3, lenMsg3
    mov edx, OFFSET decimal_three
    mov ecx, len3
    mov ebx, DECIMAL_OFFSET3
    call WriteScaled
    INVOKE PrintBuffer, OFFSET newline, 2

    ; 종료
    INVOKE ExitProcess, 0
main ENDP

END main