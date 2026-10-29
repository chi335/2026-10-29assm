.386
.model flat, stdcall
.stack 4096

; 윈도우 기본 API 선언 (외부 파일 없이 실행)
ExitProcess PROTO, dwExitCode:DWORD
GetStdHandle PROTO, nStdHandle:DWORD
WriteConsoleA PROTO, hConsoleOutput:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:PTR DWORD

INCLUDELIB kernel32.lib

.data
    decimal_one BYTE "100123456789765"                    ; 1001234567.89765
    decimal_two BYTE "900402076502015"                    ; 9004020765.02015
    sum         BYTE (SIZEOF decimal_one + 1) DUP(0), 0Dh, 0Ah, 0  ; 결과 버퍼

    bytesWritten DWORD ?

.code
main PROC
    ; 가장 마지막 자릿수(우측)부터 연산 시작
    mov esi, SIZEOF decimal_one - 1   ; 입력 문자열 인덱스 (14)
    mov edi, SIZEOF decimal_one       ; 결과 문자열 인덱스 (15)
    mov ecx, SIZEOF decimal_one       ; 루프 횟수 (15회)
    mov bh, 0                         ; Carry(올림수) 초기화

L1:
    mov ah, 0                         ; 더하기 전 AH 초기화
    mov al, decimal_one[esi]          ; 첫 번째 숫자 가져오기
    add al, bh                        ; 이전 루프의 올림수(Carry) 더하기
    aaa                               ; ASCII 연산 보정
    mov bh, ah                        ; Carry를 bh에 저장 (carry1)

    add al, decimal_two[esi]          ; 두 번째 숫자 더하기
    aaa                               ; ASCII 연산 보정
    or  bh, ah                        ; 두 과정의 Carry 합치기

    or  al, 30h                       ; 숫자 결과를 ASCII 문자로 변환
    mov sum[edi], al                  ; sum 배열에 저장

    dec esi
    dec edi
    loop L1

    ; 맨 마지막 최상위 올림수(Carry) 처리
    or  bh, 30h                       ; 올림수를 ASCII 문자로 변환
    mov sum[edi], bh                  ; sum[0] 위치에 최상위 올림수 저장

    ; 콘솔에 결과 출력
    INVOKE GetStdHandle, -11          ; STD_OUTPUT_HANDLE
    INVOKE WriteConsoleA, eax, ADDR sum, SIZEOF sum, ADDR bytesWritten, 0

    INVOKE ExitProcess, 0
main ENDP
END main