### **Problem (문제)**
> **1. In the following code sequence, show the value of AL after each shift or rotate instruction has executed:**  
> (다음 코드 시퀀스에서 각 시프트 또는 로테이트 명령어가 실행된 후 `AL` 레지스터의 값을 구하시오:)

```assembly
mov al,0D4h
shr al,1    ; a.
mov al,0D4h
sar al,1    ; b.
mov al,0D4h
sar al,4    ; c.
mov al,0D4h
rol al,1    ; d.
```

---

### **기본 개념 정리**
`0D4h`를 8비트 이진수로 변환하면 다음과 같습니다:
* `D` = $1101_2$
* `4` = $0100_2$
* **초기 AL 값**: $1101\_0100_2$ (`0xD4`)

---

### **단계별 풀이 (Step-by-Step Solution)**

#### **a. `shr al, 1` (논리 오른쪽 시프트 / Logical Shift Right)**
* **설명**: 비트를 오른쪽으로 1칸 이동하며, 가장 왼쪽(최상위 비트, MSB)에는 항상 **`0`**을 채웁니다.
* **비트 변화**:
  * 초기: $1101\_0100_2$
  * 시프트 후: $0110\_1010_2$
* **16진수 변환**: $0110_2 = 6$, $1010_2 = \text{A} \rightarrow$ **`6Ah`**

---

#### **b. `sar al, 1` (산술 오른쪽 시프트 / Arithmetic Shift Right)**
* **설명**: 비트를 오른쪽으로 1칸 이동하되, 부호 비트 유지 기능을 위해 가장 왼쪽(MSB)에 **원래 MSB 값(1)**을 유지하며 채웁니다.
* **비트 변화**:
  * 초기: $1101\_0100_2$ (MSB가 `1`)
  * 시프트 후: $1110\_1010_2$
* **16진수 변환**: $1110_2 = \text{E}$, $1010_2 = \text{A} \rightarrow$ **`EAh`**

---

#### **c. `sar al, 4` (산술 오른쪽 시프트 4회 / Arithmetic Shift Right 4 times)**
* **설명**: 비트를 오른쪽으로 4칸 이동하며, 가장 왼쪽 4개 비트를 **원래 MSB 값(`1`)**으로 채웁니다.
* **비트 변화**:
  * 초기: $1101\_0100_2$
  * 시프트 후: $1111\_1101_2$
* **16진수 변환**: $1111_2 = \text{F}$, $1101_2 = \text{D} \rightarrow$ **`FDh`**

---

#### **d. `rol al, 1` (좌측 순환 로테이트 / Rotate Left)**
* **설명**: 비트를 왼쪽으로 1칸 회전시킵니다. 밀려 나가는 가장 왼쪽 비트(`1`)가 맨 오른쪽(LSB) 위치로 되돌아옵니다.
* **비트 변화**:
  * 초기: $1101\_0100_2$ (최상위 비트 `1`)
  * 로테이트 후: $1010\_1001_2$
* **16진수 변환**: $1010_2 = \text{A}$, $1001_2 = 9 \rightarrow$ **`A9h`**

---

### **최종 정답 요약 (Summary)**

| 항목 | 명령어 | 이진수 (Binary) | 16진수 (Hex) |
| :--- | :--- | :--- | :--- |
| **a.** | `shr al, 1` | $0110\_1010_2$ | **`6Ah`** |
| **b.** | `sar al, 1` | $1110\_1010_2$ | **`EAh`** |
| **c.** | `sar al, 4` | $1111\_1101_2$ | **`FDh`** |
| **d.** | `rol al, 1` | $1010\_1001_2$ | **`A9h`** |

---

### **Problem (문제)**
> **2. In the following code sequence, show the value of AL after each shift or rotate instruction has executed:**  
> (다음 코드 시퀀스에서 각 시프트 또는 로테이트 명령어가 실행된 후 `AL` 레지스터의 값을 구하시오:)

```assembly
mov al,0D4h
ror al,3    ; a.
mov al,0D4h
rol al,7    ; b.
stc
mov al,0D4h
rcl al,1    ; c.
stc
mov al,0D4h
rcr al,3    ; d.
```

---

### **기본 개념 정리**
* **`0D4h`**: $1101\_0100_2$
* **`stc` (Set Carry Flag)**: 캐리 플래그(Carry Flag, $C$)를 **`1`**로 설정합니다.

---

### **단계별 풀이 (Step-by-Step Solution)**

#### **a. `ror al, 3` (우측 순환 로테이트 3회 / Rotate Right 3 times)**
* **설명**: 비트를 오른쪽으로 3칸 회전시킵니다. 오른쪽 끝(LSB)에서 밀려 나가는 비트가 왼쪽 끝(MSB)으로 들어옵니다.
* **비트 변화**:
  * 초기: $1101\_0100_2$
  * 1회 회전: $0110\_1010_2$
  * 2회 회전: $0011\_0101_2$
  * 3회 회전: $1001\_1010_2$
* **16진수 변환**: $1001_2 = 9$, $1010_2 = \text{A} \rightarrow$ **`9Ah`**

---

#### **b. `rol al, 7` (좌측 순환 로테이트 7회 / Rotate Left 7 times)**
* **설명**: 비트를 왼쪽으로 7칸 회전시킵니다. 8비트 레지스터에서 왼쪽으로 7칸 회전하는 것은 **오른쪽으로 1칸 회전(`ror al, 1`)하는 것과 결과가 같습니다**. ($8 - 7 = 1$)
* **비트 변화**:
  * 초기: $1101\_0100_2$
  * 로테이트 후: $0110\_1010_2$
* **16진수 변환**: $0110_2 = 6$, $1010_2 = \text{A} \rightarrow$ **`6Ah`**

---

#### **c. `stc` + `rcl al, 1` (캐리 포함 좌측 순환 로테이트 / Rotate Carry Left)**
* **설명**: 캐리 플래그($C$)를 포함하여 총 **9비트(Carry + AL)**를 왼쪽으로 1칸 회전시킵니다. (`stc`로 인해 초기 $C = 1$)
* **비트 변화**:
  * 초기 상태: $C = 1$, $\text{AL} = 1101\_0100_2$
  * AL의 최상위 비트(`1`)가 새로운 캐리 플래그($C$)가 되고, 기존 $C$ 값(`1`)이 AL의 맨 오른쪽(LSB)으로 들어갑니다.
  * 회전 후: $C = 1$, $\text{AL} = 1010\_1001_2$
* **16진수 변환**: $1010_2 = \text{A}$, $1001_2 = 9 \rightarrow$ **`A9h`**

---

#### **d. `stc` + `rcr al, 3` (캐리 포함 우측 순환 로테이트 3회 / Rotate Carry Right 3 times)**
* **설명**: 캐리 플래그($C$)를 포함하여 총 **9비트(Carry + AL)**를 오른쪽으로 3칸 회전시킵니다. (`stc`로 인해 초기 $C = 1$)
* **비트 변화**:
  * 초기 상태: $C = 1$, $\text{AL} = 1101\_0100_2$
  * 1회 회전 후: $C = 0$, $\text{AL} = 1110\_1010_2$
  * 2회 회전 후: $C = 0$, $\text{AL} = 0111\_0101_2$
  * 3회 회전 후: $C = 1$, $\text{AL} = 0011\_1010_2$
* **16진수 변환**: $0011_2 = 3$, $1010_2 = \text{A} \rightarrow$ **`3Ah`**

---

### **최종 정답 요약 (Summary)**

| 항목 | 명령어 | 이진수 (Binary) | 16진수 (Hex) |
| :--- | :--- | :--- | :--- |
| **a.** | `ror al, 3` | $1001\_1010_2$ | **`9Ah`** |
| **b.** | `rol al, 7` | $0110\_1010_2$ | **`6Ah`** |
| **c.** | `stc` / `rcl al, 1` | $1010\_1001_2$ | **`A9h`** |
| **d.** | `stc` / `rcr al, 3` | $0011\_1010_2$ | **`3Ah`** |

---

### **Problem (문제)**
> **3. What will be the contents of AX and DX after the following operation?**  
> (다음 연산이 실행된 후 `AX`와 `DX` 레지스터에 저장되는 값은 무엇인가?)

```assembly
mov dx,0
mov ax,222h
mov cx,100h
mul cx
```

---

### **기본 개념 정리**
* **16비트 곱셈 명령어 `mul cx`**:
  * `mul` 명령어에 16비트 피연산자(`cx`)가 사용되면, 자동으로 **`AX` 레지스터의 값과 피연산자를 곱합니다**.
  * 연산식: $\text{DX:AX} \leftarrow \text{AX} \times \text{CX}$
  * 연산 결과는 32비트 크기가 되므로, **상위 16비트는 `DX`**, **하위 16비트는 `AX`**에 나누어 저장됩니다.

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **레지스터 초기화**:
   * `AX` = `0222h`
   * `CX` = `0100h`
   * `DX` = `0000h`

2. **곱셈 연산 수행 (`mul cx`)**:
   * $222_{16} \times 100_{16}$ 연산을 수행합니다.
   * 16진수에서 `100h`를 곱하는 것은 자릿수를 왼쪽으로 2칸(8비트) 이동시키는 것과 같습니다.
   * $\text{결과} = 0002\_2200_{16}$ (32비트 값)

3. **결과값 레지스터 분할 저장**:
   * **상위 16비트 (`DX`)**: `0002h`
   * **하위 16비트 (`AX`)**: `2200h`

---

### **최종 정답 요약 (Summary)**

* **`AX`** = **`2200h`**
* **`DX`** = **`0002h`**

---

### **Problem (문제)**
> **4. What will be the contents of AX after the following operation?**  
> (다음 연산이 실행된 후 `AX` 레지스터에 저장되는 값은 무엇인가?)

```assembly
mov ax,63h
mov bl,10h
div bl
```

---

### **기본 개념 정리**
* **8비트 나눗셈 명령어 `div bl`**:
  * `div` 명령어에 8비트 피연산자(`bl`)가 사용되면, **`AX` 레지스터의 값을 피연산자로 나눕니다**.
  * 연산식: $\text{AX} \div \text{BL}$
  * 연산 결과는 다음과 같이 나눠서 저장됩니다:
    * **`AL`**: 나눗셈의 **몫 (Quotient)**
    * **`AH`**: 나눗셈의 **나머지 (Remainder)**

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **레지스터 초기화**:
   * 피나눗수(Dividend): `AX` = `0063h` (10진수로 $99$)
   * 나눗수(Divisor): `BL` = `10h` (10진수로 $16$)

2. **나눗셈 연산 수행 (`div bl`)**:
   * $63_{16} \div 10_{16}$ 연산을 수행합니다 (10진수 $99 \div 16$).
   * **몫 (Quotient)**: $6$ (`06h`)
   * **나머지 (Remainder)**: $3$ (`03h`)

3. **결과값 레지스터 저장**:
   * `AL` (몫) = `06h`
   * `AH` (나머지) = `03h`
   * 따라서 전체 `AX` (`AH` + `AL`) = **`0306h`**

---

### **최종 정답 요약 (Summary)**

* **`AX`** = **`0306h`** (`AH` = `03h`, `AL` = `06h`)

---

### **Problem (문제)**
> **5. What will be the contents of EAX and EDX after the following operation?**  
> (다음 연산이 실행된 후 `EAX`와 `EDX` 레지스터에 저장되는 값은 무엇인가?)

```assembly
mov eax,123400h
mov edx,0
mov ebx,10h
div ebx
```

---

### **기본 개념 정리**
* **32비트 나눗셈 명령어 `div ebx`**:
  * `div` 명령어에 32비트 피연산자(`ebx`)가 사용되면, **`EDX:EAX` 64비트 쌍**으로 합쳐진 값을 피연산자로 나눕니다.
  * 연산식: $\text{EDX:EAX} \div \text{EBX}$
  * 연산 결과는 다음과 같이 나누어 저장됩니다:
    * **`EAX`**: 나눗셈의 **몫 (Quotient)**
    * **`EDX`**: 나눗셈의 **나머지 (Remainder)**

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **레지스터 초기화**:
   * 피나눗수(64비트 Dividend): `EDX:EAX` = `00000000_00123400h` ($123400_{16}$)
   * 나눗수(32비트 Divisor): `EBX` = `00000010h` ($10_{16}$)

2. **나눗셈 연산 수행 (`div ebx`)**:
   * $123400_{16} \div 10_{16}$ 연산을 수행합니다.
   * 16진수에서 `10h`로 나누는 것은 자릿수를 오른쪽으로 1칸 이동시키는 것과 같습니다.
   * **몫 (Quotient)**: $12340_{16}$ (`00012340h`)
   * **나머지 (Remainder)**: $0_{16}$ (`00000000h`)

3. **결과값 레지스터 저장**:
   * **`EAX`** (몫) = `00012340h` (또는 `12340h`)
   * **`EDX`** (나머지) = `00000000h` (또는 `0h`)

---

### **최종 정답 요약 (Summary)**

* **`EAX`** = **`00012340h`**
* **`EDX`** = **`00000000h`**


---

### **Problem (문제)**
> **6. What will be the contents of AX and DX after the following operation?**  
> (다음 연산이 실행된 후 `AX`와 `DX` 레지스터에 저장되는 값은 무엇인가?)

```assembly
mov ax,4000h
mov dx,500h
mov bx,10h
div bx
```

---

### **기본 개념 정리**
* **16비트 나눗셈 명령어 `div bx`**:
  * `div` 명령어에 16비트 피연산자(`bx`)가 사용되면, **`DX:AX` 32비트 쌍**으로 합쳐진 값을 피연산자로 나눕니다.
  * 연산식: $\text{DX:AX} \div \text{BX}$
  * 연산 결과:
    * **`AX`**: 나눗셈의 **몫 (Quotient)** (최대 16비트 크기인 `FFFFh`까지 저장 가능)
    * **`DX`**: 나눗셈의 **나머지 (Remainder)**

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **레지스터 초기화**:
   * 피나눗수(32비트 Dividend): `DX:AX` = `05004000h`
   * 나눗수(16비트 Divisor): `BX` = `0010h`

2. **나눗셈 연산 수행 (`div bx`)**:
   * $05004000_{16} \div 10_{16}$ 연산을 수행합니다.
   * 계산된 **몫**: **`00500400h`**

3. **오버플로우(Overflow) 발생 검사**:
   * 16비트 레지스터인 `AX`에 저장할 수 있는 최댓값은 **`FFFFh`** (10진수로 $65,535$)입니다.
   * 계산된 몫 `00500400h`는 `FFFFh`를 훨씬 초과하므로 **16비트 `AX` 레지스터에 담을 수 없습니다**.
   * 따라서 x86 CPU는 **`Divide Error` (Divide Overflow / 나눗셈 오버플로우 예외)** 인터럽트를 발생시킵니다.

---

### **최종 정답 요약 (Summary)**

* **결과**: **Divide Overflow (Divide Error Exception) 발생**
* **설명**: 계산된 몫(`500400h`)이 16비트 레지스터 `AX`의 최대 수용 범위(`FFFFh`)를 초과하여 **나눗셈 오버플로우 예외**가 발생하며, 연산이 정상 종료되지 않습니다.

---

### **Problem (문제)**
> **7. What will be the contents of BX after the following instructions execute?**  
> (다음 명령어들이 실행된 후 `BX` 레지스터에 저장되는 값은 무엇인가?)

```assembly
mov bx,5
stc
mov ax,60h
adc bx,ax
```

---

### **기본 개념 정리**
* **`stc` (Set Carry Flag)**: 캐리 플래그(Carry Flag, $CF$)를 **`1`**로 설정합니다.
* **`adc` (Add with Carry)**: 두 피연산자의 합에 캐리 플래그($CF$) 값까지 함께 더합니다.
  * 연산식: $\text{BX} \leftarrow \text{BX} + \text{AX} + CF$

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **`mov bx, 5`**: `BX` = `0005h`
2. **`stc`**: 캐리 플래그 설정 ($CF = 1$)
3. **`mov ax, 60h`**: `AX` = `0060h`
4. **`adc bx, ax`**:
   * $\text{BX} = \text{BX} + \text{AX} + CF$
   * $\text{BX} = 0005_{16} + 0060_{16} + 1_{16} = 0066_{16}$

---

### **최종 정답 요약 (Summary)**

* **`BX`** = **`0066h`** (또는 10진수로 **`102`**)

---


### **Problem (문제)**
> **8. Describe the output when the following code executes in 64-bit mode:**  
> (64비트 모드에서 다음 코드가 실행될 때의 결과를 설명하시오:)

```assembly
.data
dividend_hi  QWORD 00000108h
dividend_lo  QWORD 33300020h
divisor      QWORD 00000100h
.code
mov  rdx,dividend_hi
mov  rax,dividend_lo
div  divisor
```

---

### **기본 개념 정리**
* **64비트 나눗셈 명령어 `div divisor`**:
  * 64비트 모드에서 `div` 명령어에 64비트 피연산자(`divisor`)가 사용되면, **`RDX:RAX` 128비트 쌍**으로 합쳐진 값을 피연산자로 나눕니다.
  * 연산식: $\text{RDX:RAX} \div \text{divisor}$
  * **몫(Quotient)**은 **`RAX`**(64비트)에, **나머지(Remainder)**는 **`RDX`**(64비트)에 저장됩니다.
* **나눗셈 오버플로우 조건**:
  * 피나눗수의 상위 64비트(`RDX`)가 나눗수(`divisor`)보다 크거나 같으면($\text{RDX} \ge \text{divisor}$), 몫이 64비트 최댓값($2^{64}-1$)을 초과하게 되어 **Divide Error Exception (나눗셈 오버플로우 예외)**가 발생합니다.

---

### **단계별 분석 (Step-by-Step Analysis)**

1. **레지스터 값 설정**:
   * `RDX` (상위 64비트) = `0000000000000108h`
   * `RAX` (하위 64비트) = `0000000033300020h`
   * `divisor` (나눗수) = `0000000000000100h`

2. **오버플로우 여부 검사**:
   * `RDX` (`108h`) 와 `divisor` (`100h`)를 비교합니다.
   * `108h` $>$ `100h` 이므로, **`RDX` $\ge$ `divisor` 조건이 성립**합니다.

3. **계산된 몫 확인**:
   * $128\text{비트 피나눗수} = 108\_00000000\_33300020_{16}$
   * $108\_00000000\_33300020_{16} \div 100_{16} = 1\_08000000\_00333000_{16}$ (몫)
   * 계산된 몫($1\_08000000\_00333000_{16}$)은 17자리 16진수로, 64비트 레지스터 `RAX`가 담을 수 있는 최대 범위(16자리 16진수, `FFFFFFFFFFFFFFFFh`)를 초과합니다.

---

### **최종 정답 요약 (Summary)**

* **결과**: **Divide Error Exception (나눗셈 오버플로우 예외 / #DE) 발생**
* **설명**: `RDX`에 들어있는 상위 비트 값(`108h`)이 나눗수(`100h`)보다 크기 때문에, 나눗셈 결과(몫)가 64비트 레지스터인 `RAX`의 최대 용량을 초과하여 프로그램이 예외 오류를 발생시키고 중단됩니다.

---


### **Problem (문제)**
> **9. The following program is supposed to subtract val2 from val1. Find and correct all logic errors (CLC clears the Carry flag):**  
> (다음 프로그램은 val1에서 val2를 빼기 위한 코드이다. 모든 논리적 오류를 찾아 수정하시오.)

```assembly
.data
val1   QWORD 20403004362047A1h
val2   QWORD 055210304A2630B2h
result QWORD 0
.code
mov  cx,8 
mov  esi,val1 
mov  edi,val2
clc 
top:
mov  al,BYTE PTR[esi] 
sbb  al,BYTE PTR[edi] 
mov  BYTE PTR[esi],al 
dec  esi
dec  edi
loop top
```

---

### **발견된 논리적 오류 (Logic Errors Found)**

1. **값과 주소의 혼동 (Loading Values Instead of Addresses)**:
   * `mov esi, val1` 및 `mov edi, val2`는 변수의 **메모리 주소**가 아닌 **값 자체**를 가져옵니다. 포인터로 사용하려면 `OFFSET` 키워드를 사용해 주소를 대입해야 합니다.

2. **포인터 이동 방향 오류 (`dec` $\rightarrow$ `inc`)**:
   * 리틀 엔디언(Little-Endian) 방식에서 `OFFSET val1`은 가장 낮은 바이트(LSB)를 가리킵니다. 다중 바이트 뺄셈(`sbb`)은 반드시 **LSB에서 MSB(높은 바이트) 방향**으로 진행되어야 하므로, 주소를 줄이는 `dec`가 아니라 늘리는 **`inc`**를 사용해야 합니다.
   * (*참고: x86에서 `inc`와 `dec` 명령어는 캐리 플래그($CF$)를 변경하지 않으므로 `sbb` 연산 유지에 안전합니다.*)

3. **루프 카운터 register 크기 오류 (`cx` $\rightarrow$ `ecx`)**:
   * 32비트 모드에서 `loop` 명령어는 `ECX` 전체를 카운터로 참조합니다. `mov cx, 8`을 사용하면 `ECX` 상위 16비트에 남아있는 쓰레기 값 때문에 원하는 횟수(8회)만큼 정확히 반복되지 않을 수 있으므로 **`mov ecx, 8`**로 초기화해야 합니다.

4. **결과 저장 위치 오류 (`result` 변수 미사용)**:
   * `.data` 영역에 `result` 변수가 선언되어 있음에도 결과값을 `val1` 위치(`esi`)에 덮어쓰고 있습니다. 결과를 `result`에 저장하도록 포인터(`ebx`)를 추가해야 합니다.

---

### **수정된 코드 (Corrected Code)**

```assembly
.data
val1   QWORD 20403004362047A1h
val2   QWORD 055210304A2630B2h
result QWORD 0

.code
mov  ecx,8             ; 32비트 ECX 레지스터로 루프 카운터 8 설정
mov  esi,OFFSET val1   ; val1의 시작 주소(LSB)를 ESI에 대입
mov  edi,OFFSET val2   ; val2의 시작 주소(LSB)를 EDI에 대입
mov  ebx,OFFSET result ; result의 시작 주소를 EBX에 대입
clc                    ; 첫 바이트 뺄셈 전 Carry Flag 초기화 (CF = 0)

top:
mov  al,BYTE PTR[esi]  ; val1에서 1바이트 가져오기
sbb  al,BYTE PTR[edi]  ; val2의 1바이트와 Borrow(CF)를 함께 뺌
mov  BYTE PTR[ebx],al  ; 결과를 result 변수에 저장
inc  esi               ; 다음 바이트로 이동 (LSB -> MSB)
inc  edi               ; 다음 바이트로 이동
inc  ebx               ; result의 다음 바이트 포인터 증가
loop top               ; ECX를 1 감소시키고 0이 아니면 top으로 이동
```

---

### **Problem (문제)**
> **10. What will be the hexadecimal contents of RAX after the following instructions execute in 64-bit mode?**  
> (64비트 모드에서 다음 명령어들이 실행된 후 `RAX` 레지스터의 16진수 값은 무엇인가?)

```assembly
.data
multiplicand QWORD 0001020304050000h
.code
imul rax,multiplicand, 4
```

---

### **기본 개념 정리**
* ** 피연산자가 3개인 `imul` (부호 있는 곱셈) 명령어**:
  * 구문: `imul 목적지, 피연산자, 즉시값`
  * 연산식: $\text{목적지(RAX)} \leftarrow \text{피연산자(multiplicand)} \times \text{즉시값(4)}$
  * 64비트 모드에서 `0001020304050000h` 값 전체에 `4`를 곱한 결과가 64비트 `RAX` 레지스터에 저장됩니다.

---

### **단계별 풀이 (Step-by-Step Solution)**

1. **피연산자 값 확인**:
   * `multiplicand` = $0001\_0203\_0405\_0000_{16}$
   * 즉시값 = $4$

2. **곱셈 연산 수행 ($0001\_0203\_0405\_0000_{16} \times 4$)**:
   * 16비트(4자리 16진수) 단위로 나누어 4를 곱하면 다음과 같이 계산됩니다:
     * $0001_{16} \times 4 = \mathbf{0004_{16}}$
     * $0203_{16} \times 4 = \mathbf{080C_{16}}$ ($2_{16} \times 4 = 8$, $3_{16} \times 4 = \text{C}_{16}$)
     * $0405_{16} \times 4 = \mathbf{1014_{16}}$ ($4_{16} \times 4 = 10_{16}$, $5_{16} \times 4 = 14_{16}$)
     * $0000_{16} \times 4 = \mathbf{0000_{16}}$

3. **결과 결합**:
   * $\text{RAX} = 0004\_080\text{C}\_1014\_0000_{16}$

---

### **최종 정답 요약 (Summary)**

* **`RAX`** = **`0004080C10140000h`** (또는 **`4080C10140000h`**)

---
