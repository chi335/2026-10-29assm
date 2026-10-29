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

    ; 출력용 메시지
    msgHeader   BYTE "=== Bitwise Multiplication Test ===", 13, 10, 13, 10, 0
    msgMul      BYTE " * ", 0
    msgEqu      BYTE " = ", 0
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
; PrintDec: 양의 정수(EAX)를 콘솔에 10진수로 출력
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
    push edx            ; 자릿수 스택 저장
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
; BitwiseMultiply
; 비트 이동(Shift)과 더하기(Add)만을 사용하여 두 무부호 정수를 곱합니다.
;
; Receives:
;   EAX = 피승수 (Multiplicand)
;   EBX = 승수 (Multiplier)
; Returns:
;   EAX = 곱셈 결과 (Product)
; ------------------------------------------------------------------
BitwiseMultiply PROC
    push ebx
    push ecx
    push edx

    mov ecx, eax        ; ECX = 피승수 (EAX) 복사
    mov edx, 0          ; EDX = 누적 곱셈 결과 버퍼 (0으로 초기화)

MulLoop:
    cmp ebx, 0          ; 승수(EBX)가 0이면 곱셈 완료
    je MulDone

    shr ebx, 1          ; 승수를 우측으로 1비트 이동 (LSB가 Carry Flag로 들어감)
    jnc SkipAdd         ; Carry Flag가 0이면 더하지 않고 건너뜀

    add edx, ecx        ; Carry Flag가 1이면 누적 결과에 피승수를 더함

SkipAdd:
    shl ecx, 1          ; 피승수를 좌측으로 1비트 이동 (2배 증가)
    jmp MulLoop

MulDone:
    mov eax, edx        ; 최종 연산 결과를 EAX로 반환

    pop edx
    pop ecx
    pop ebx
    ret
BitwiseMultiply ENDP

; ------------------------------------------------------------------
; RunMulTest: BitwiseMultiply 테스트 및 결과 출력
; ------------------------------------------------------------------
RunMulTest PROC val1:DWORD, val2:DWORD
    pushad

    ; 1. "val1 * val2 = " 형식으로 출력
    INVOKE PrintDec, val1
    INVOKE PrintBuffer, OFFSET msgMul, 3
    INVOKE PrintDec, val2
    INVOKE PrintBuffer, OFFSET msgEqu, 3

    ; 2. BitwiseMultiply 호출 (EAX = val1, EBX = val2)
    mov eax, val1
    mov ebx, val2
    call BitwiseMultiply

    ; 3. 반환된 곱셈 결과(EAX) 출력
    INVOKE PrintDec, eax
    INVOKE PrintBuffer, OFFSET newline, 2

    popad
    ret
RunMulTest ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 헤더 출력
    INVOKE PrintBuffer, OFFSET msgHeader, 37

    ; 다양한 값 곱셈 테스트 (EAX * EBX)
    INVOKE RunMulTest, 5, 3
    INVOKE RunMulTest, 25, 100
    INVOKE RunMulTest, 1234, 5678
    INVOKE RunMulTest, 0, 9999
    INVOKE RunMulTest, 65535, 32

    INVOKE ExitProcess, 0
main ENDP

END main