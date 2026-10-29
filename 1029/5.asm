.386
.model flat, c
option casemap :none

; 비주얼 스튜디오 최신 C 런타임 및 Win32 라이브러리 자동 연결
includelib ucrt.lib
includelib msvcrt.lib
includelib legacy_stdio_definitions.lib
includelib kernel32.lib

; 외부 함수 선언
printf      PROTO C :ptr byte, :VARARG
ExitProcess PROTO stdcall :dword        ; exit 대신 Windows 표준 ExitProcess 사용

.data
    buffer    BYTE 33 DUP(0)
    testVal   DWORD 11010101b    
    fmtStr    BYTE "Binary Result: %s", 0Ah, 0

.code
main PROC
    mov eax, testVal          
    mov esi, OFFSET buffer    
    
    ; 비트 변환 프로시저 호출
    call BinToAscPROC
    
    ; 결과 출력 (printf 호출)
    INVOKE printf, ADDR fmtStr, ADDR buffer

    ; 안전한 프로그램 종료 (ExitProcess 사용)
    INVOKE ExitProcess, 0
main ENDP


;-------------------------------------------------------
BinToAscPROC PROC
    push ecx
    push esi                ; ESI 초기 주소 보존
    mov ecx, 32             
    
L1: 
    shl eax, 1              
    mov BYTE PTR [esi], '0' 
    jnc L2                  
    mov BYTE PTR [esi], '1' 
    
L2: 
    inc esi                 
    loop L1                 
    
    mov BYTE PTR [esi], 0   ; 버퍼 끝에 널 문자 추가

    pop esi                 ; 저장했던 ESI 원복
    pop ecx
    ret
BinToAscPROC ENDP

END main