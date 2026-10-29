.386
.model flat, stdcall
.stack 4096

; 윈도우 종료 함수 선언
ExitProcess PROTO, dwExitCode:DWORD

.data
    buffer BYTE 33 DUP(0)       ; 32비트 문자열 공간 + 널 문자
    testVal DWORD 0AFB2C13Ch    ; 테스트 값

.code
main PROC
    ; 1. 테스트 값과 버퍼 주소 설정
    mov eax, testVal
    mov esi, OFFSET buffer
    
    ; 2. 변환 함수 호출
    call BinToAsc
    
    ; 3. 프로그램 정상 종료 (윈도우 API 호출)
    INVOKE ExitProcess, 0
main ENDP


; --- 사용자가 작성한 변환 함수 ---
BinToAsc PROC
    ; Converts 32-bit binary integer to ASCII binary.
    ; Receives: EAX = binary integer, ESI points to buffer
    ; Returns: buffer filled with ASCII binary digits
    ;-------------------------------------------------------
    push ecx
    push esi
    
    mov ecx, 32             ; number of bits in EAX
    
L1: 
    shl eax, 1              ; shift high bit into Carry flag
    mov BYTE PTR [esi], '0' ; choose 0 as default digit
    jnc L2                  ; if no Carry, jump to L2
    mov BYTE PTR [esi], '1' ; else move 1 to buffer
    
L2: 
    inc esi                 ; next buffer position
    loop L1                 ; shift another bit to left
    
    pop esi
    pop ecx
    ret
BinToAsc ENDP

END main                    ; 프로그램의 시작점 명시