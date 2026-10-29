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

MAX_NUM = 1000

.data
    hStdOut DWORD 0
    bytesWritten DWORD 0

    ; 에라토스테네스의 체 배열 (0 ~ 1000, 총 1001바이트)
    ; 0 = 소수(Prime), 1 = 합성수/소수 아님(Composite)
    sieve BYTE 1001 DUP(0)

    ; 출력용 문자 및 메시지
    spaceChar BYTE " ", 0
    newline   BYTE 13, 10, 0
    numBuf    BYTE 12 DUP(0)

    msgHeader BYTE "=== Sieve of Eratosthenes: Prime Numbers (2 ~ 1000) ===", 13, 10, 13, 10, 0
    msgCount  BYTE 13, 10, "Total Prime Numbers Found: ", 0

.code

; ------------------------------------------------------------------
; PrintBuffer: 콘솔 출력 헬퍼 함수
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; PrintDec: 양의 정수(EAX)를 오른쪽 정렬하여 콘솔에 출력
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
    push edx            ; 자릿수를 스택에 저장
    inc ecx
    cmp eax, 0
    jne ConvertLoop

    mov digitCount, ecx

    ; 줄맞춤을 위해 4자리 폭 기준 정렬 (공백 패딩)
    mov ebx, 4
    sub ebx, ecx
    jbe PrintDigits

PadLoop:
    INVOKE PrintBuffer, OFFSET spaceChar, 1
    dec ebx
    jnz PadLoop

PrintDigits:
    mov ecx, digitCount
    mov esi, OFFSET numBuf

PopLoop:
    pop edx
    add dl, '0'         ; 숫자를 ASCII 문자로 변환
    mov [esi], dl
    inc esi
    loop PopLoop

    INVOKE PrintBuffer, OFFSET numBuf, digitCount

    popad
    ret
PrintDec ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 헤더 출력
    INVOKE PrintBuffer, OFFSET msgHeader, 57

    ; -------------------------------------------------------------
    ; 1. 에라토스테네스의 체 알고리즘 수행
    ; -------------------------------------------------------------
    ; 0과 1은 소수가 아니므로 1(합성수)로 표시
    mov sieve[0], 1
    mov sieve[1], 1

    mov esi, 2          ; ESI = i (2부터 시작)

SieveOuter:
    cmp esi, 31         ; sqrt(1000) ≈ 31.62 이므로 31까지만 검사
    ja SieveDone

    ; sieve[esi]가 0(소수)인지 확인
    cmp sieve[esi], 0
    jne NextI

    ; j = i * i 부터 시작하여 i씩 증가하며 배수들을 제거 (1로 표시)
    mov eax, esi
    imul eax, esi       ; EAX = j = i * i

SieveInner:
    cmp eax, MAX_NUM
    ja NextI

    mov sieve[eax], 1   ; 소수의 배수는 합성수로 표시

    add eax, esi        ; j += i
    jmp SieveInner

NextI:
    inc esi
    jmp SieveOuter

SieveDone:

    ; -------------------------------------------------------------
    ; 2. 결과 출력 (한 줄에 10개씩 예쁘게 정렬하여 출력)
    ; -------------------------------------------------------------
    mov ebx, 2          ; EBX = 검사할 숫자 (2 ~ 1000)
    mov edi, 0          ; EDI = 발견된 총 소수 개수
    mov edx, 0          ; EDX = 한 줄 출력 개수 카운터

PrintPrimesLoop:
    cmp ebx, MAX_NUM
    ja PrintDone

    cmp sieve[ebx], 0
    jne NextNumber      ; 0이 아니면 소수가 아님

    ; 소수 발견!
    inc edi             ; 소수 개수 증가
    INVOKE PrintDec, ebx; 숫자 출력
    INVOKE PrintBuffer, OFFSET spaceChar, 1

    ; 10개 출력할 때마다 줄바꿈
    inc edx
    cmp edx, 10
    jne NextNumber
    INVOKE PrintBuffer, OFFSET newline, 2
    mov edx, 0          ; 줄 카운터 리셋

NextNumber:
    inc ebx
    jmp PrintPrimesLoop

PrintDone:
    ; 총 소수 개수 출력 (2~1000 사이 소수는 총 168개)
    INVOKE PrintBuffer, OFFSET msgCount, 29
    INVOKE PrintDec, edi
    INVOKE PrintBuffer, OFFSET newline, 2

    INVOKE ExitProcess, 0
main ENDP

END main