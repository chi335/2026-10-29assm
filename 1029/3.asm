.386
.model flat, stdcall
.stack 4096

; 윈도우 API 함수 선언
ExitProcess PROTO, dwExitCode:DWORD
GetStdHandle PROTO, nStdHandle:DWORD
WriteConsoleA PROTO, hConsoleOutput:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:PTR DWORD
wsprintfA PROTO C, lpOut:PTR BYTE, lpFmt:PTR BYTE, :VARARG

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    ; 예시 데이터 (4바이트 크기의 두 수)
    first_number  BYTE 12h, 34h, 56h, 78h    ; 첫 번째 수
    second_number BYTE 87h, 65h, 43h, 21h    ; 두 번째 수
    ARR_LEN       EQU LENGTHOF first_number   ; 배열의 길이 (4)

    sum           BYTE (ARR_LEN + 1) DUP(0)  ; 최종 결과를 저장할 배열 (Carry용 1바이트 추가)
    carry         BYTE 0                     ; Carry(올림수) 저장 변수

    fmtStr        BYTE "Sum Result: %02X %02X %02X %02X %02X", 0Dh, 0Ah, 0
    buffer        BYTE 64 DUP(0)
    bytesWritten  DWORD ?

.code
main PROC
    ; 1. esi (index) = length of first_number - 1
    mov esi, ARR_LEN - 1

    ; 2. edi (index) = length of first_number
    mov edi, ARR_LEN

    ; 3. ecx = length of first_number
    mov ecx, ARR_LEN

    ; 4. set carry value to 0
    mov carry, 0

AddLoop:
    ; 5. acc = first_number[esi]
    mov al, first_number[esi]

    ; 6. add previous carry to acc & save carry in carry1
    add al, carry
    mov bl, 0
    adc bl, 0               ; 첫 번째 더하기에서 발생한 Carry를 bl에 저장 (carry1)

    ; 7. acc += second_number[esi]
    add al, second_number[esi]
    adc bl, 0               ; 두 번째 더하기에서 발생한 Carry를 bl에 합산

    ; 8. OR the carry with carry1
    mov carry, bl           ; 발생한 Carry를 다음 루프를 위해 저장

    ; 9. sum[edi] = acc
    mov sum[edi], al

    ; 10. dec edi ( 및 esi 감소)
    dec edi
    dec esi

    ; 11. Until ecx == 0
    loop AddLoop            ; ecx를 1 감속하고 0이 아니면 AddLoop로 이동

    ; 12. Store last carry digit in sum
    mov al, carry
    mov sum[0], al          ; 가장 앞자리(sum[0])에 마지막 Carry 저장

    ; --- [결과 출력 부분] ---
    movzx eax, sum[4]
    push eax
    movzx eax, sum[3]
    push eax
    movzx eax, sum[2]
    push eax
    movzx eax, sum[1]
    push eax
    movzx eax, sum[0]
    push eax
    push OFFSET fmtStr
    push OFFSET buffer
    call wsprintfA
    add esp, 28             ; C 호출 규약 매개변수 정리

    INVOKE GetStdHandle, -11
    INVOKE WriteConsoleA, eax, ADDR buffer, 35, ADDR bytesWritten, 0

    INVOKE ExitProcess, 0
main ENDP
END main