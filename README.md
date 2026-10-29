# Integer Arithmetic (정수 연산)

어셈블리 언어에서의 비트 단위 이동(Shift), 회전(Rotate), 정수 곱셈 및 나눗셈, 확장 연산(ADC/SBB), 10진 연산 조정 명령어를 정리한 문서입니다.

---

## 📑 목차
1. [Shift and Rotate Instructions (쉬프트 및 회전 명령어)](#1-shift-and-rotate-instructions)
2. [Shift and Rotate Applications (쉬프트 및 회전 응용)](#2-shift-and-rotate-applications)
3. [Multiplication and Division Instructions (곱셈 및 나눗셈 명령어)](#3-multiplication-and-division-instructions)
4. [Extended Addition and Subtraction (확장 가산 및 감산)](#4-extended-addition-and-subtraction)
5. [ASCII and Unpacked Decimal Arithmetic (ASCII 및 언팩 10진 연산)](#5-ascii-and-unpacked-decimal-arithmetic)
6. [Packed Decimal Arithmetic (팩 10진 연산)](#6-packed-decimal-arithmetic)

---

## 1. Shift and Rotate Instructions

### 1.1 논리 쉬프트 vs 산술 쉬프트 (Logical & Arithmetic Shifts)
- **논리 쉬프트(Logical Shift)**: 빈 자리를 `0`으로 채우고, 빠져나가는 비트는 **Carry Flag (CF)**에 저장됩니다.
- **산술 쉬프트(Arithmetic Shift)**: 부호 비트(MSB)를 유지하면서 이동합니다. `SAR`의 경우 최상위 부호 비트가 `1`이면 `1`로, `0`이면 `0`으로 채워집니다.

| 명령어 | 이름 | 설명 |
| :--- | :--- | :--- |
| `SHL` | Shift Left | 논리 좌측 쉬프트 (비트 좌측 이동, 빈자리 0, MSB는 CF) |
| `SHR` | Shift Right | 논리 우측 쉬프트 (비트 우측 이동, 빈자리 0, LSB는 CF) |
| `SAL` | Shift Arithmetic Left | 산술 좌측 쉬프트 (`SHL`과 동작 동일) |
| `SAR` | Shift Arithmetic Right | 산술 우측 쉬프트 (최상위 부호 비트 유지) |

```assembly
mov bl, 8Fh     ; 10001111b
shl bl, 1       ; BL = 00011110b, CF = 1

mov dl, 5       ; 00000101b (5)
shl dl, 1       ; 00001010b (10 -> 2배 곱셈 효과)
```

---

### 1.2 회전 명령어 (Rotate Instructions)
- **ROL / ROR**: 순환 회전을 수행하며, 빠져나가는 비트가 반대편 비트 위치와 **CF**에 저장됩니다.
- **RCL / RCR**: **Carry Flag**까지 포함하여 전체 비트가 고리 형태로 회전합니다.

| 명령어 | 이름 | 설명 |
| :--- | :--- | :--- |
| `ROL` | Rotate Left | 좌측 순환 회전 |
| `ROR` | Rotate Right | 우측 순환 회전 |
| `RCL` | Rotate Carry Left | CF를 포함한 좌측 순환 회전 |
| `RCR` | Rotate Carry Right | CF를 포함한 우측 순환 회전 |

```assembly
; ROL 예시
mov al, 40h     ; 01000000b
rol al, 1       ; AL = 10000000b, CF = 0

; RCL 예시
clc             ; CF = 0 (Clear Carry Flag)
mov bl, 88h     ; 10001000b
rcl bl, 1       ; CF = 1, BL = 00010000b
```

---

### 1.3 이중 정밀도 쉬프트 (Double-Precision Shift)
두 개의 피연산자를 조합하여 비트를 연속 이동시킵니다.

- **`SHLD dest, src, count`**: `dest`를 좌측으로 shift하고, 채워질 하위 비트는 `src`의 상위 비트에서 가져옵니다.
- **`SHRD dest, src, count`**: `dest`를 우측으로 shift하고, 채워질 상위 비트는 `src`의 하위 비트에서 가져옵니다.

```assembly
mov ax, 0AC36h
shld wval, ax, 4   ; wval에 ax의 상위 4비트 이동
```

---

## 2. Shift and Rotate Applications

1. **비트 단위 곱셈/나눗셈**: 2의 거듭제곱($2^n$) 형태의 빠른 곱셈 및 나눗셈 처리 (`SHL`, `SHR`, `SAR`).
2. **다중 더블워드 쉬프트 (Shifting Multiple Doublewords)**: 64비트 이상의 대형 데이터 배열을 연속적으로 shift할 때 `SHRD`/`SHLD` 활용.
3. **파일 날짜 필드 추출 (Extracting File Date Fields)**:
   - 비트 마스크(`AND`)와 shift 연산을 활용하여 비트 단위로 압축된 MS-DOS 날짜 포맷에서 년/월/일 추출.

```assembly
; MS-DOS 날짜 구조 (DX): Year(비트 9-15), Month(비트 5-8), Day(비트 0-4)
mov al, dl
and al, 00011111b    ; Day 추출 (하위 5비트)
mov day, al

mov ax, dx
shr ax, 5            ; Month 위치로 Shift
and al, 00001111b    ; Month 추출 (4비트)
mov month, al
```

---

## 3. Multiplication and Division Instructions

### 3.1 부호 없는 곱셈/나눗셈 (`MUL` / `DIV`)
곱셈 연산의 결과 크기는 피연산자 크기의 **2배**가 됩니다.

#### MUL (Unsigned Multiply)
| 피연산자 크기 | 곱해지는 레지스터 | 결과 저장 위치 |
| :--- | :--- | :--- |
| 8-bit | AL * reg/mem8 | AX |
| 16-bit | AX * reg/mem16 | DX:AX |
| 32-bit | EAX * reg/mem32 | EDX:EAX |

#### DIV (Unsigned Divide)
| 피연산자 크기 | 피나눗수 (Dividend) | 몫 (Quotient) | 나머지 (Remainder) |
| :--- | :--- | :--- | :--- |
| 8-bit | AX | AL | AH |
| 16-bit | DX:AX | AX | DX |
| 32-bit | EDX:EAX | EAX | EDX |

---

### 3.2 부호 있는 곱셈/나눗셈 (`IMUL` / `IDIV`)
- **`IMUL`**: 1개, 2개, 3개 피연산자 포맷을 지원하여 유연하게 곱셈을 수행합니다.
- **`IDIV`**: 나눗셈 실행 전, 피나눗수의 부호 확장(Sign Extension)이 필요합니다.

#### 부호 확장 명령어 (Sign Extension Instructions)
- **`CBW`** (Convert Byte to Word): AL -> AX
- **`CWD`** (Convert Word to Doubleword): AX -> DX:AX
- **`CDQ`** (Convert Doubleword to Quadword): EAX -> EDX:EAX

```assembly
.data
byteVal SBYTE -48
.code
mov al, byteVal   ; AL = -48 (D0h)
cbw               ; AX = -48 (FFD0h, 부호 확장)
mov bl, +5
idiv bl           ; AL = 몫(-9), AH = 나머지(-3)
```

---

## 4. Extended Addition and Subtraction

32비트를 초과하는 대형 정수(64비트, 128비트 등)의 연산 시 Carry/Borrow를 반영하여 연산합니다.

- **`ADC` (Add with Carry)**: $Dest = Dest + Src + CarryFlag$
- **`SBB` (Subtract with Borrow)**: $Dest = Dest - Src - CarryFlag$

```assembly
; 64비트 덧셈 예시 (EDX:EAX + EBX:ECX)
add eax, ecx      ; 하위 32비트 덧셈
adc edx, ebx      ; 상위 32비트 덧셈 + Carry Flag 반영
```

---

## 5. ASCII and Unpacked Decimal Arithmetic

ASCII 문자 형식('0' ~ '9') 또는 Unpacked BCD 형식의 연산 결과를 보정하는 명령어입니다.

| 명령어 | 이름 | 설명 |
| :--- | :--- | :--- |
| `AAA` | ASCII Adjust after Addition | 덧셈 후 ASCII 결과 조정 |
| `AAS` | ASCII Adjust after Subtraction | 뺄셈 후 ASCII 결과 조정 |
| `AAM` | ASCII Adjust after Multiplication | 곱셈 후 Unpacked BCD 결과 조정 |
| `AAD` | ASCII Adjust before Division | 나눗셈 전 2자리 Unpacked BCD를 이진수로 조정 |

```assembly
; AAM 예시
mov bl, 05h
mov al, 06h
mul bl          ; AX = 001Eh (30)
aam             ; AX = 0300h (AH=3, AL=0 Unpacked BCD)
```

---

## 6. Packed Decimal Arithmetic

1바이트에 2개의 10진수 숫자(00~99)를 저장하는 Packed BCD 연산 후 결과를 조정합니다.

- **`DAA` (Decimal Adjust after Addition)**: ADD/ADC 연산 후 AL 레지스터를 BCD로 보정
- **`DAS` (Decimal Adjust after Subtraction)**: SUB/SBB 연산 후 AL 레지스터를 BCD로 보정

```assembly
mov al, 35h
add al, 48h     ; AL = 7Dh
daa             ; AL = 83h (Packed BCD 조정 결과)
```
