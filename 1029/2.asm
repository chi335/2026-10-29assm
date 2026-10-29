.386
.model flat, stdcall
.stack 4096

; 윈도우 기본 API 함수 선언 (외부 라이브러리 파일 필요 없음)
ExitProcess PROTO, dwExitCode:DWORD
GetStdHandle PROTO, nStdHandle:DWORD
WriteConsoleA PROTO, hConsoleOutput:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:PTR DWORD
wsprintfA PROTO C, lpOut:PTR BYTE, lpFmt:PTR BYTE, :VARARG

; 윈도우 기본 라이브러리 링크 (Visual Studio에 기본 포함되어 있음)
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
packed_1 WORD 4536h
packed_2 WORD 7207h
sum      DWORD 0

fmtStr   BYTE "%08X", 0Dh, 0Ah, 0     ; 16진수 출력 포맷 (%08X) 및 줄바꿈
buffer   BYTE 32 DUP(0)                ; 출력할 문자열 저장 버퍼
bytesWritten DWORD ?

.code
main PROC
    ; 1. sum 및 index 초기화
    mov sum, 0
    mov esi, 0

    ; 2. 하위 바이트 더하기 (36h + 07h)
    mov al, BYTE PTR packed_1[esi]
    add al, BYTE PTR packed_2[esi]
    daa                         ; BCD 보정
    mov BYTE PTR sum[esi], al

    ; 3. 상위 바이트 더하기 (45h + 72h + 올림수)
    inc esi
    mov al, BYTE PTR packed_1[esi]
    adc al, BYTE PTR packed_2[esi]
    daa                         ; BCD 보정
    mov BYTE PTR sum[esi], al

    ; 4. 최종 올림수(Carry) 처리
    inc esi
    mov al, 0
    adc al, 0
    mov BYTE PTR sum[esi], al

    ; 5. sum 값을 16진수 문자열로 변환 (WriteHex 역할)
    INVOKE wsprintfA, ADDR buffer, ADDR fmtStr, sum

    ; 6. 콘솔에 결과 출력 (WriteConsoleA 함수 사용)
    INVOKE GetStdHandle, -11     ; -11 = STD_OUTPUT_HANDLE (콘솔 출력 핸들)
    INVOKE WriteConsoleA, eax, ADDR buffer, 10, ADDR bytesWritten, 0

    ; 7. 프로그램 종료
    INVOKE ExitProcess, 0
main ENDP
END main