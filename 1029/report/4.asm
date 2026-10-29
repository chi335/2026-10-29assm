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

.data
    hStdOut DWORD 0
    bytesWritten DWORD 0

    ; -------------------------------------------------------------
    ; 암호화 키 배열 (10바이트)
    ; 음수 = 비트 좌측 회전 (ROL)
    ; 양수 = 비트 우측 회전 (ROR)
    ; 0 = 회전 없음
    ; -------------------------------------------------------------
    key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
    KEY_SIZE = $ - key

    ; 테스트 데이터 세트 1
    msg1      BYTE "Assembly Language Programming 2026!", 0
    len1      DWORD 35

    ; 테스트 데이터 세트 2
    msg2      BYTE "Visual Studio MASM Rotate Cipher Test", 0
    len2      DWORD 37

    ; 출력용 메시지
    hdrMsg    BYTE "=== Rotate Encryption Test ===", 13, 10, 13, 10, 0
    test1Hdr  BYTE "[Test Data Set 1]", 13, 10, 0
    test2Hdr  BYTE "[Test Data Set 2]", 13, 10, 0
    lblOrig   BYTE " Original Message : ", 0
    lblEnc    BYTE " Encrypted Message: ", 0
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
; RotateEncrypt
; 각 평문 바이트를 키 배열에 정의된 방향과 횟수만큼 비트 회전시킵니다.
;
; Receives:
;   ESI = 평문 메시지 시작 주소 (PTR BYTE)
;   ECX = 메시지 바이트 길이 (DWORD)
;   EDI = 키 배열 시작 주소 (PTR BYTE)
;   EBX = 키 배열 크기 (DWORD)
; ------------------------------------------------------------------
RotateEncrypt PROC
    pushad

    mov edx, 0          ; EDX = 키 배열 인덱스 (0 ~ KEY_SIZE - 1)

EncryptLoop:
    cmp ecx, 0
    je Done             ; 메시지의 모든 바이트 처리가 끝나면 종료

    ; 1. 현재 키 바이트 가져오기
    mov al, [edi + edx] ; AL = key[EDX]

    ; 2. 키 값 판별 (0, 양수, 음수)
    cmp al, 0
    je NextByte         ; 키가 0이면 회전하지 않고 건너뜀
    jl RotateLeft       ; 키가 음수이면 좌측 회전 (ROL)

RotateRight:            ; 키가 양수이면 우측 회전 (ROR)
    push ecx
    mov cl, al
    ror byte ptr [esi], cl
    pop ecx
    jmp NextByte

RotateLeft:             ; 키가 음수이면 절댓값만큼 좌측 회전 (ROL)
    push ecx
    neg al              ; 음수를 양수로 변환 (절댓값 구하기)
    mov cl, al
    rol byte ptr [esi], cl
    pop ecx

NextByte:
    inc esi             ; 다음 메시지 바이트 주소로 이동

    ; 3. 키 인덱스 순환 (10바이트 마다 반복)
    inc edx
    cmp edx, ebx        ; 키 배열 크기에 도달하면 0으로 재설정
    jb ContinueLoop
    mov edx, 0

ContinueLoop:
    dec ecx
    jmp EncryptLoop

Done:
    popad
    ret
RotateEncrypt ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 전체 헤더 출력
    INVOKE PrintBuffer, OFFSET hdrMsg, 34

    ; ==============================================================
    ; [테스트 1] 첫 번째 데이터 세트 암호화
    ; ==============================================================
    INVOKE PrintBuffer, OFFSET test1Hdr, 19

    ; 1. 암호화 전 원래 메시지 출력
    INVOKE PrintBuffer, OFFSET lblOrig, 20
    INVOKE PrintBuffer, OFFSET msg1, len1
    INVOKE PrintBuffer, OFFSET newline, 2

    ; 2. RotateEncrypt 호출
    mov esi, OFFSET msg1
    mov ecx, len1
    mov edi, OFFSET key
    mov ebx, KEY_SIZE
    call RotateEncrypt

    ; 3. 암호화 후 메시지 출력
    INVOKE PrintBuffer, OFFSET lblEnc, 20
    INVOKE PrintBuffer, OFFSET msg1, len1
    INVOKE PrintBuffer, OFFSET newline, 2
    INVOKE PrintBuffer, OFFSET newline, 2

    ; ==============================================================
    ; [테스트 2] 두 번째 데이터 세트 암호화
    ; ==============================================================
    INVOKE PrintBuffer, OFFSET test2Hdr, 19

    ; 1. 암호화 전 원래 메시지 출력
    INVOKE PrintBuffer, OFFSET lblOrig, 20
    INVOKE PrintBuffer, OFFSET msg2, len2
    INVOKE PrintBuffer, OFFSET newline, 2

    ; 2. RotateEncrypt 호출
    mov esi, OFFSET msg2
    mov ecx, len2
    mov edi, OFFSET key
    mov ebx, KEY_SIZE
    call RotateEncrypt

    ; 3. 암호화 후 메시지 출력
    INVOKE PrintBuffer, OFFSET lblEnc, 20
    INVOKE PrintBuffer, OFFSET msg2, len2
    INVOKE PrintBuffer, OFFSET newline, 2

    INVOKE ExitProcess, 0
main ENDP

END main