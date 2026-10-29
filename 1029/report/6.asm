.386
.model flat, stdcall
option casemap:none

; 윈도우 기본 시스템 라이브러리 자동 링크 (외부 파일 필요 없음)
includelib kernel32.lib

; 윈도우 API 함수 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
    hStdOut DWORD 0
    bytesWritten DWORD 0

    ; 출력용 문자열
    msgHeader   BYTE "=== Greatest Common Divisor (GCD) Test ===", 13, 10, 13, 10, 0
    strGCD      BYTE "GCD( ", 0
    strComma    BYTE ", ", 0
    strClose    BYTE " ) = ", 0
    minusChar   BYTE "-", 0
    newline     BYTE 13, 10, 0
    numBuf      BYTE 12 DUP(0)

.code

; ------------------------------------------------------------------
; PrintBuffer: 콘솔 출력 헬퍼 함수
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; PrintDec: 양의 정수를 10진수로 출력
; ------------------------------------------------------------------
PrintDec PROC val:DWORD
    LOCAL digitCount:DWORD
    pushad

    mov eax, val
    mov ecx, 0          ; 자릿수 카운터
    mov ebx, 10         ; 10진수 나누기용

ConvertLoop:
    mov edx, 0
    div ebx             ; EAX = 몫, EDX = 나머지
    push edx            ; 자릿수 스택에 저장
    inc ecx
    cmp eax, 0
    jne ConvertLoop

    mov digitCount, ecx
    mov esi, OFFSET numBuf

PopLoop:
    pop edx
    add dl, '0'         ; ASCII 문자로 변환
    mov [esi], dl
    inc esi
    loop PopLoop

    INVOKE PrintBuffer, OFFSET numBuf, digitCount

    popad
    ret
PrintDec ENDP

; ------------------------------------------------------------------
; PrintSignedDec: 부호 있는 정수를 콘솔에 출력 (음수일 때 '-' 표시)
; ------------------------------------------------------------------
PrintSignedDec PROC val:SDWORD
    push eax
    mov eax, val

    cmp eax, 0
    jge IsPositive

    ; 음수 처리
    INVOKE PrintBuffer, OFFSET minusChar, 1
    neg eax

IsPositive:
    INVOKE PrintDec, eax
    pop eax
    ret
PrintSignedDec ENDP

; ------------------------------------------------------------------
; GCD 프로시저 (유클리드 호제법)
; Receives:
;   EAX = 정수 x
;   EBX = 정수 y
; Returns:
;   EAX = 최대공약수
; ------------------------------------------------------------------
GCD PROC
    push ebx
    push ecx
    push edx

    ; 1. x = abs(x)
    cmp eax, 0
    jge AbsX_Done
    neg eax
AbsX_Done:

    ; 2. y = abs(y)
    cmp ebx, 0
    jge AbsY_Done
    neg ebx
AbsY_Done:

    ; y가 0이면 x(EAX) 반환
    cmp ebx, 0
    je GCD_Done

GCDLoop:
    ; n = x % y
    mov edx, 0
    div ebx             ; EAX / EBX -> 몫: EAX, 나머지(n): EDX

    ; x = y
    mov eax, ebx

    ; y = n
    mov ebx, edx

    ; while (y > 0)
    cmp ebx, 0
    jg GCDLoop

GCD_Done:
    pop edx
    pop ecx
    pop ebx
    ret
GCD ENDP

; ------------------------------------------------------------------
; RunGCDTest: 테스트 및 결과 출력
; ------------------------------------------------------------------
RunGCDTest PROC xVal:SDWORD, yVal:SDWORD
    pushad

    INVOKE PrintBuffer, OFFSET strGCD, 5
    INVOKE PrintSignedDec, xVal
    INVOKE PrintBuffer, OFFSET strComma, 2
    INVOKE PrintSignedDec, yVal
    INVOKE PrintBuffer, OFFSET strClose, 5

    ; GCD 호출
    mov eax, xVal
    mov ebx, yVal
    call GCD

    ; 결과 출력
    INVOKE PrintDec, eax
    INVOKE PrintBuffer, OFFSET newline, 2

    popad
    ret
RunGCDTest ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    INVOKE PrintBuffer, OFFSET msgHeader, 43

    ; 5가지 예제 테스트 호출
    INVOKE RunGCDTest, 24, 36
    INVOKE RunGCDTest, -48, 18
    INVOKE RunGCDTest, 100, -75
    INVOKE RunGCDTest, 17, 13
    INVOKE RunGCDTest, -1024, -256

    INVOKE ExitProcess, 0
main ENDP

END main