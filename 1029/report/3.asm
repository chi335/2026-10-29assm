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
    ; 5개의 팩 십진수(Packed Decimal) 테스트 데이터 (4바이트 DWORD)
    ; 팩 십진수는 각 니블(4비트) 하나가 십진수 한 자리를 의미합니다.
    ; -------------------------------------------------------------
    packed1 DWORD 12345678h
    packed2 DWORD 05432109h
    packed3 DWORD 99887766h
    packed4 DWORD 00001234h
    packed5 DWORD 20261029h

    ; 변환된 ASCII 문자열을 저장할 버퍼 (8자리 숫자 + Null 종료)
    buffer BYTE 10 DUP(0)

    ; 콘솔 출력용 메시지
    msgHeader BYTE "=== Packed Decimal to ASCII Conversion ===", 13, 10, 0
    msgPrefix BYTE "Packed Decimal -> ASCII: ", 0
    newline   BYTE 13, 10, 0

.code

; ------------------------------------------------------------------
; PrintBuffer: 콘솔에 지정된 길이의 문자열 출력
; ------------------------------------------------------------------
PrintBuffer PROC pBuf:PTR BYTE, bufLen:DWORD
    INVOKE WriteConsoleA, hStdOut, pBuf, bufLen, ADDR bytesWritten, 0
    ret
PrintBuffer ENDP

; ------------------------------------------------------------------
; PackedToAsc
; 4바이트 팩 십진수를 8자리 ASCII 문자열로 변환합니다.
;
; Receives:
;   EAX = 4바이트 팩 십진수 값 (DWORD)
;   ESI = ASCII 문자열을 저장할 버퍼 주소 (OFFSET buffer)
; Returns:
;   ESI가 가리키는 버퍼에 변환된 ASCII 문자열 저장
; ------------------------------------------------------------------
PackedToAsc PROC
    push eax
    push ebx
    push ecx
    push esi

    mov ecx, 8          ; 4바이트(32비트)는 8개의 니블(4비트)로 구성됨

ConvertLoop:
    rol eax, 4          ; 상위 니블을 4비트 좌측 회전하여 AL 하위에 위치시킴
    mov bl, al
    and bl, 0Fh         ; 하위 4비트(니블)만 추출
    add bl, 30h         ; ASCII 숫자로 변환 ('0' = 30h)
    mov [esi], bl       ; 버퍼에 ASCII 문자 저장
    inc esi             ; 버퍼 포인터 이동
    loop ConvertLoop

    mov byte ptr [esi], 0 ; 문자열 끝에 Null 문자 추가

    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
PackedToAsc ENDP

; ------------------------------------------------------------------
; RunTest: PackedToAsc를 테스트하고 결과를 출력하는 헬퍼 프로시저
; ------------------------------------------------------------------
RunTest PROC packedVal:DWORD
    pushad

    ; 1. 안내 메시지 출력
    INVOKE PrintBuffer, OFFSET msgPrefix, 25

    ; 2. PackedToAsc 호출
    mov eax, packedVal
    mov esi, OFFSET buffer
    call PackedToAsc

    ; 3. 변환된 ASCII 결과 출력 (8글자)
    INVOKE PrintBuffer, OFFSET buffer, 8

    ; 4. 줄바꿈
    INVOKE PrintBuffer, OFFSET newline, 2

    popad
    ret
RunTest ENDP

; ------------------------------------------------------------------
; main 메인 엔트리 포인트
; ------------------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 헤더 출력
    INVOKE PrintBuffer, OFFSET msgHeader, 43

    ; 5개 팩 십진수 데이터 테스트 진행
    INVOKE RunTest, packed1
    INVOKE RunTest, packed2
    INVOKE RunTest, packed3
    INVOKE RunTest, packed4
    INVOKE RunTest, packed5

    INVOKE ExitProcess, 0
main ENDP

END main