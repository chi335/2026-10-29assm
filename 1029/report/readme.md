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


### **Problem (문제)**
> **1. Write a sequence of shift instructions that cause AX to be sign-extended into EAX. In other words, the sign bit of AX is copied into the upper 16 bits of EAX. Do not use the CWD instruction.**  
> (`AX`의 값이 `EAX`로 부호 확장(Sign-extend)되도록 만드는 시프트 명령어 시퀀스를 작성하시오. 즉, `AX`의 부호 비트가 `EAX`의 상위 16비트에 복사되어야 합니다. `CWD` 명령어는 사용하지 마시오.)

---

### **풀이 및 아이디어 (Solution & Idea)**

1. **`shl eax, 16` (논리 좌측 시프트 16비트)**:
   * `EAX`를 왼쪽으로 16비트 이동시킵니다.
   * 원래 `AX`에 있던 16비트 값이 `EAX`의 **상위 16비트 위치**로 이동하고, 하위 16비트는 `0`으로 채워집니다.
   * 이 과정에서 `AX`의 원래 부호 비트(15번 비트)가 `EAX` 전체의 최상위 부호 비트(31번 비트) 위치로 배치됩니다.

2. **`sar eax, 16` (산술 우측 시프트 16비트)**:
   * `EAX`를 오른쪽으로 16비트 산술 이동시킵니다.
   * `sar` 명령어의 특성상 최상위 비트(31번 부호 비트)의 값이 유지되면서 오른쪽으로 채워지므로, **상위 16비트 전체가 원래 `AX`의 부호 비트로 복사**되어 내려옵니다.

---

### **정답 코드 (Answer Code)**

```assembly
shl eax, 16    ; AX의 값을 EAX의 상위 16비트로 이동 (부호 비트가 31번 위치로 감)
sar eax, 16    ; 산술 우측 시프트를 통해 상위 16비트를 부호 비트로 채움
```

---

### **작동 예시 (Example)**

* **음수 예시 (`AX` = `8000h`, 부호 비트 = `1`)**:
  1. 초기 `EAX` = `????8000h`
  2. `shl eax, 16` $\rightarrow$ `80000000h`
  3. `sar eax, 16` $\rightarrow$ **`FFFF8000h`** (상위 16비트가 `1`로 채워짐)

* **양수 예시 (`AX` = `7FFFh`, 부호 비트 = `0`)**:
  1. 초기 `EAX` = `????7FFFh`
  2. `shl eax, 16` $\rightarrow$ `7FFF0000h`
  3. `sar eax, 16` $\rightarrow$ **`00007FFFh`** (상위 16비트가 `0`으로 채워짐)
 
---

### **Problem (문제)**
> **2. Suppose the instruction set contained no rotate instructions. Show how you would use SHR and a conditional jump instruction to rotate the contents of the AL register 1 bit to the right.**  
> (명령어 세트에 로테이트 명령어가 없다고 가정합니다. `SHR`과 조건 분기(Jump) 명령어를 사용하여 `AL` 레지스터의 내용을 오른쪽으로 1비트 순환(Rotate Right)시키는 코드를 작성하시오.)

---

### **풀이 및 아이디어 (Solution & Idea)**

* **`ror al, 1` (우측 로테이트)** 연산의 동작 원리는 다음과 같습니다:
  1. `AL`의 모든 비트를 오른쪽으로 1칸 이동합니다.
  2. 맨 오른쪽 비트(LSB, 0번 비트)가 밀려 나가면서 최상위 비트(MSB, 7번 비트) 자리로 이동합니다.

* **`shr al, 1` (논리 우측 시프트)**을 실행하면:
  * 모든 비트가 오른쪽으로 1칸 이동합니다.
  * 최상위 비트(7번 비트)에는 항상 **`0`**이 채워집니다.
  * 밀려 나간 맨 오른쪽 비트(LSB)는 **캐리 플래그($CF$)**에 저장됩니다.

* **조건 분기 적용 방법**:
  * `shr al, 1` 실행 후 **$CF = 0$**이면, 밀려 나간 비트가 `0`이었으므로 최상위 비트에 `0`이 들어가 있는 현재 상태가 그대로 정답입니다.
  * 만약 **$CF = 1$**이면, 밀려 나간 비트가 `1`이었으므로 최상위 비트(7번 비트, `80h`)를 **`1`로 변경**해 주어야 합니다 (`or al, 80h`).

---

### **정답 코드 (Answer Code)**

```assembly
    shr al, 1       ; AL을 오른쪽으로 1비트 이동 (밀려난 LSB는 Carry Flag에 저장됨)
    jnc L1          ; Carry Flag가 0이면(NC: No Carry) L1으로 점프 (이미 MSB가 0임)
    or  al, 80h     ; Carry Flag가 1이면 MSB(7번 비트)를 1로 설정 (1000 0000b)
L1:
```

---

### **작동 예시 (Example)**

* **예시 1: LSB가 `1`인 경우 (`AL` = `D4h` = `1101 0100b`)**:
  * 초기: `1101 0100b` (LSB = `0`)
  1. `shr al, 1` $\rightarrow$ `AL` = `0110 1010b`, $CF = 0$
  2. `jnc L1` 조건 만족하여 점프
  3. 결과: **`6Ah`** (`0110 1010b`) $\rightarrow$ 우측 회전 정상 완료!

* **예시 2: LSB가 `1`인 경우 (`AL` = `D5h` = `1101 0101b`)**:
  * 초기: `1101 0101b` (LSB = `1`)
  1. `shr al, 1` $\rightarrow$ `AL` = `0110 1010b`, $CF = 1$
  2. `jnc L1` 점프하지 않음
  3. `or al, 80h` $\rightarrow$ `0110 1010b OR 1000 0000b` = **`1110 1010b` (`EAh`)**
  4. 결과: **`EAh`** $\rightarrow$ 맨 오른쪽 `1`이 맨 왼쪽으로 들어와 우측 회전 정상 완료!
 
---

### **Problem (문제)**
> **3. Write a logical shift instruction that multiplies the contents of EAX by 16.**  
> (`EAX` 레지스터의 값에 16을 곱하는 논리 시프트 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* 이진수에서 비트를 왼쪽으로 1칸 시프트(`shl`)할 때마다 값은 **2배($2^1$)**씩 증가합니다.
* $16 = 2^4$ 이므로, 비트를 **왼쪽으로 4칸** 이동시키면 원래 값에 $16$을 곱한 것과 동일한 결과가 됩니다.
* 논리 좌측 시프트 명령어인 **`shl`**을 사용합니다.

---

### **정답 코드 (Answer Code)**

```assembly
shl eax, 4    ; EAX 레지스터의 값을 왼쪽으로 4비트 시프트 (EAX * 16 연산 수행)
```

---

### **Problem (문제)**
> **4. Write a logical shift instruction that divides EBX by 4.**  
> (`EBX` 레지스터의 값을 4로 나누는 논리 시프트 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* 이진수에서 부호 없는 정수(Unsigned Integer)의 비트를 오른쪽으로 1칸 논리 시프트(`shr`)할 때마다 값은 **2로 나눈 몫($\div 2^1$)**이 됩니다.
* $4 = 2^2$ 이므로, 비트를 **오른쪽으로 2칸** 이동시키면 원래 값을 $4$로 나눈 효과가 나타납니다.
* 논리 우측 시프트 명령어인 **`shr`**을 사용합니다.

---

### **정답 코드 (Answer Code)**

```assembly
shr ebx, 2    ; EBX 레지스터의 값을 오른쪽으로 2비트 시프트 (EBX / 4 연산 수행)
```

---

### **Problem (문제)**
> **5. Write a single rotate instruction that exchanges the high and low halves of the DL register.**  
> (`DL` 레지스터의 상위 4비트(High Nibble)와 하위 4비트(Low Nibble)를 서로 교환하는 단일 로테이트 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* `DL`은 **8비트** 크기의 레지스터입니다.
* 8비트 레지스터에서 상위 4비트와 하위 4비트의 위치를 서로 맞바꾸려면 비트를 왼쪽이나 오른쪽으로 **4비트 만큼 회전(Rotate)**시키면 됩니다.
* 따라서 `rol` (좌측 회전) 또는 `ror` (우측 회전) 명령어에 회전 수 **`4`**를 지정해주면 두 영역이 서로 교환됩니다.

---

### **정답 코드 (Answer Code)**

```assembly
rol dl, 4    ; DL 레지스터의 비트를 왼쪽으로 4칸 회전 (상위 4비트와 하위 4비트 교환)
```
*(또는 `ror dl, 4` 도 동일하게 정답입니다.)*

---

### **작동 예시 (Example)**

* **초기 `DL` 값**: `A5h` ($1010\,0101_2$)
  * 상위 4비트: `Ah` ($1010_2$)
  * 하위 4비트: `5h` ($0101_2$)
* **`rol dl, 4` 실행 후**: `5Ah` ($0101\,1010_2$)
  * 상위 4비트와 하위 4비트의 위치가 서로 교환됨!
 
---

### **Problem (문제)**
> **6. Write a single SHLD instruction that shifts the highest bit of the AX register into the lowest bit position of DX and shifts DX one bit to the left.**  
> (`AX` 레지스터의 최상위 비트를 `DX` 레지스터의 최하위 비트 위치로 이동시키고, `DX`를 왼쪽으로 1비트 시프트하는 단일 `SHLD` 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* **`SHLD` (Shift Left Double) 명령어 구문**:
  * `SHLD destination, source, count`
* **동작 원리**:
  1. `destination` 레지스터의 비트들을 왼쪽으로 `count`만큼 시프트합니다.
  2. 시프트되면서 비어버린 `destination`의 오른쪽(하위 비트) 자리에 **`source` 레지스터의 상위 `count`개 비트**를 복사해서 채워 넣습니다.
  3. `source` 레지스터의 값은 변경되지 않고 그대로 유지됩니다.

* **문제 조건 적용**:
  * 목적지 (`destination`): `DX`
  * 소스 (`source`): `AX`
  * 이동할 비트 수 (`count`): `1`

---

### **정답 코드 (Answer Code)**

```assembly
shld dx, ax, 1    ; DX를 왼쪽으로 1비트 시프트하고, 비어있는 DX의 LSB에 AX의 MSB를 채움
```

---

### **작동 예시 (Example)**

* **초기 상태**:
  * `AX` = `8000h` ($1000\,0000\,0000\,0000_2$, 최상위 비트 = **`1`**)
  * `DX` = `0000h` ($0000\,0000\,0000\,0000_2$)

* **`shld dx, ax, 1` 실행 후**:
  * `DX`가 왼쪽으로 1비트 이동하고, `AX`의 최상위 비트(`1`)가 `DX`의 최하위 비트로 들어감
  * `DX` = `0001h` ($0000\,0000\,0000\,0001_2$)
  * `AX` = `8000h` (원래 값 유지)
 
---
### **Problem (문제)**
> **7. Write a sequence of instructions that shift three memory bytes to the right by 1 bit position. Use the following test data:**  
> `byteArray BYTE 81h,20h,33h`  
> (3바이트의 메모리 배열 데이터를 오른쪽으로 1비트 시프트하는 명령어 시퀀스를 작성하시오. 제공된 테스트 데이터를 사용하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* **다중 바이트 우측 시프트(Multi-byte Shift Right) 원리**:
  * 3바이트 전체를 하나의 연결된 비트열로 보고 오른쪽으로 1비트 시프트할 때는 **가장 높은 바이트(MSB, `byteArray[2]`)부터 시작하여 하위 바이트로** 연산을 진행해야 합니다.
  * **가장 높은 바이트 (`byteArray+2`)**: `shr` 명령어로 오른쪽 시프트합니다. 이 때 밀려나가는 맨 오른쪽 비트는 **캐리 플래그($CF$)**에 저장됩니다.
  * **중간 및 하위 바이트 (`byteArray+1`, `byteArray`)**: `rcr` (Rotate Carry Right) 명령어를 사용합니다. 이전 연산에서 캐리 플래그($CF$)에 저장된 비트가 최상위 비트 위치로 들어오면서 오른쪽으로 시프트됩니다.

---

### **정답 코드 (Answer Code)**

```assembly
shr BYTE PTR [byteArray + 2], 1    ; 가장 높은 바이트(33h)를 우측 시프트 (밀려난 비트는 CF에 저장)
rcr BYTE PTR [byteArray + 1], 1    ; CF의 비트를 20h의 MSB로 받아오면서 우측 회전 시프트
rcr BYTE PTR [byteArray], 1        ; CF의 비트를 81h의 MSB로 받아오면서 우측 회전 시프트
```

---

### **작동 과정 및 결과 확인 (Example & Verification)**

* **초기 상태 (24비트 데이터)**:
  * `byteArray+2` (`33h`) = $0011\,0011_2$
  * `byteArray+1` (`20h`) = $0010\,0000_2$
  * `byteArray+0` (`81h`) = $1000\,0001_2$

* **단계별 연산**:
  1. `shr [byteArray + 2], 1`:
     * `33h` ($0011\,0011_2$) $\rightarrow$ **`19h`** ($0001\,1001_2$), 캐리 플래그 $CF = \mathbf{1}$
  2. `rcr [byteArray + 1], 1`:
     * `20h` ($0010\,0000_2$) + $CF(1)$ $\rightarrow$ **`90h`** ($1001\,0000_2$), 캐리 플래그 $CF = \mathbf{0}$
  3. `rcr [byteArray], 1`:
     * `81h` ($1000\,0001_2$) + $CF(0)$ $\rightarrow$ **`40h`** ($0100\,0000_2$), 캐리 플래그 $CF = \mathbf{1}$

* **최종 변환된 메모리 결과**:
  * `byteArray` = **`40h, 90h, 19h`**
 
 ---

 ### **Problem (문제)**
> **8. Write a sequence of instructions that shift three memory words to the left by 1 bit position. Use the following test data:**  
> `wordArray WORD 810Dh, 0C064h, 93ABh`  
> (3개의 메모리 워드(WORD) 데이터를 왼쪽으로 1비트 시프트하는 명령어 시퀀스를 작성하시오. 제공된 테스트 데이터를 사용하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* **다중 워드 좌측 시프트(Multi-word Shift Left) 원리**:
  * WORD(16비트 = 2바이트) 단위로 구성된 배열 전체를 왼쪽으로 1비트 연결하여 시프트할 때는 **가장 낮은 워드(LSW, `wordArray[0]`)부터 시작하여 상위 워드로** 연산을 진행해야 합니다.
  * **가장 낮은 워드 (`wordArray`)**: `shl` 명령어로 왼쪽 시프트합니다. 이 때 밀려나가는 맨 왼쪽 비트(MSB)는 **캐리 플래그($CF$)**에 저장됩니다.
  * **상위 워드들 (`wordArray+2`, `wordArray+4`)**: `rcl` (Rotate Carry Left) 명령어를 사용합니다. 이전 연산에서 캐리 플래그($CF$)에 저장된 비트가 최하위 비트(LSB) 위치로 들어오면서 왼쪽으로 시프트됩니다.
* **주소 오프셋 주의점**: `WORD` 타잎은 요소당 **2바이트**를 차지하므로 오프셋이 `+2`, `+4`로 증가합니다.

---

### **정답 코드 (Answer Code)**

```assembly
shl WORD PTR [wordArray], 1        ; 가장 낮은 워드(810Dh)를 좌측 시프트 (밀려난 MSB는 CF에 저장)
rcl WORD PTR [wordArray + 2], 1    ; CF의 비트를 C064h의 LSB로 받아오면서 좌측 회전 시프트
rcl WORD PTR [wordArray + 4], 1    ; CF의 비트를 93ABh의 LSB로 받아오면서 좌측 회전 시프트
```

---

### **작동 과정 및 결과 확인 (Example & Verification)**

* **초기 상태**:
  * `wordArray+0` (`810Dh`) = $1000\,0001\,0000\,1101_2$
  * `wordArray+2` (`0C064h`) = $1100\,0000\,0110\,0100_2$
  * `wordArray+4` (`93ABh`) = $1001\,0011\,1010\,1011_2$

* **단계별 연산**:
  1. `shl [wordArray], 1`:
     * `810Dh` $\rightarrow$ **`021Ah`** ($0000\,0010\,0001\,1010_2$), 캐리 플래그 $CF = \mathbf{1}$
  2. `rcl [wordArray + 2], 1`:
     * `0C064h` + $CF(1)$ $\rightarrow$ **`80C9h`** ($1000\,0000\,1100\,1001_2$), 캐리 플래그 $CF = \mathbf{1}$
  3. `rcl [wordArray + 4], 1`:
     * `93ABh` + $CF(1)$ $\rightarrow$ **`2757h`** ($0010\,0111\,0101\,0111_2$), 캐리 플래그 $CF = \mathbf{1}$

* **최종 변환된 메모리 결과**:
  * `wordArray` = **`021Ah, 80C9h, 2757h`**
 
---
### **Problem (문제)**
> **9. Write instructions that multiply 5 by 3 and store the result in a 16-bit variable val1.**  
> (5에 3을 곱하고 그 결과를 16비트 변수 `val1`에 저장하는 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* **16비트 변수 선언**: `val1`은 16비트 변수이므로 `.data` 영역에 `WORD` 타입으로 정의합니다.
* **곱셈 처리**:
  * x86 어셈블리에서는 16비트 레지스터(`AX`)를 거쳐서 계산 후 메모리에 저장합니다.
  * `imul` (또는 `mul`) 명령어를 활용하여 $5 \times 3$ 연산을 수행한 뒤 `mov` 명령어로 `val1`에 할당합니다.

---

### **정답 코드 (Answer Code)**

```assembly
.data
val1 WORD ?          ; 16비트 변수 선언

.code
mov ax, 5            ; AX 레지스터에 5 대입
imul ax, 3           ; AX = AX * 3 (결과: 15 / 000Fh)
mov val1, ax         ; 연산 결과를 16비트 변수 val1에 저장
```

---

### **대안 코드 (`mul` 명령어 사용 시)**

```assembly
mov ax, 5            ; AX 레지스터에 5 대입
mov bx, 3            ; BX 레지스터에 3 대입
mul bx               ; AX = AX * BX (DX:AX에 저장되나 16비트 범위 내이므로 AX에 15가 저장됨)
mov val1, ax         ; 연산 결과를 val1에 저장
```

---

### **Problem (문제)**
> **10. Write instructions that divide 276 by 10 and store the result in a 16-bit variable val1.**  
> (276을 10으로 나눈 나눗셈의 몫을 16비트 변수 `val1`에 저장하는 명령어를 작성하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

* **16비트 나눗셈 (`div bx`) 동작 원리**:
  * 16비트 레지스터로 나눗셈을 수행할 때는 **`DX:AX` 32비트 쌍**을 피나눗수로 사용합니다.
  * 따라서 나눗셈 수행 전 `DX`는 `0`으로 초기화하고, `AX`에는 피나눗수(`276`)를 입력해야 합니다.
  * `div bx` 연산 수행 후:
    * **`AX`**: 나눗셈의 **몫 (Quotient)** 저장 $\rightarrow$ $276 \div 10 = \mathbf{27}$
    * **`DX`**: 나눗셈의 **나머지 (Remainder)** 저장 $\rightarrow$ $276 \pmod{10} = \mathbf{6}$
* 몫이 보관된 `AX` 레지스터의 값을 16비트 변수 `val1`에 저장합니다.

---

### **정답 코드 (Answer Code)**

```assembly
.data
val1 WORD ?          ; 16비트 변수 선언

.code
mov dx, 0            ; DX:AX 피나눗수 형성을 위해 DX 상위 비트를 0으로 초기화
mov ax, 276          ; AX에 피나눗수 276 대입
mov bx, 10           ; BX에 나눗수 10 대입
div bx               ; DX:AX를 BX(10)로 나눔 (AX = 몫 27, DX = 나머지 6)
mov val1, ax         ; 몫이 담긴 AX의 값(27)을 val1에 저장
```

---

### **Problem (문제)**
> **11. Implement the following C++ expression in assembly language, using 32-bit unsigned operands:**  
> `val1 = (val2 * val3) / (val4 - 3)`  
> (32비트 부호 없는(Unsigned) 피연산자를 사용하여 C++ 수식 `val1 = (val2 * val3) / (val4 - 3)`을 어셈블리어로 구현하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

1. **변수 타입**: 32비트 부호 없는 정수이므로 `.data` 영역에 **`DWORD`** 타입으로 변수를 준비합니다.
2. **곱셈 연산 (`val2 * val3`)**:
   * 부호 없는 곱셈이므로 **`mul`** 명령어를 사용합니다.
   * `EAX`에 `val2`를 대입 후 `mul val3`을 수행하면 64비트 연산 결과가 **`EDX:EAX` 레지스터 쌍**에 자동으로 저장됩니다.
3. **뺄셈 연산 (`val4 - 3`)**:
   * 분모 값을 계산하기 위해 `EBX` 레지스터에 `val4`를 복사한 후 `3`을 뺍니다.
4. **나눗셈 연산 (`/`)**:
   * 부호 없는 나눗셈이므로 **`div`** 명령어를 사용합니다.
   * `div ebx`를 실행하면 `EDX:EAX`에 저장된 곱셈 결과를 `EBX`로 나누게 됩니다.
   * 연산 결과 몫(Quotient)은 **`EAX`**에 저장됩니다.
5. **대입 연산 (`val1 = ...`)**:
   * `EAX`에 저장된 몫을 `val1` 변수에 대입합니다.

---

### **정답 코드 (Answer Code)**

```assembly
.data
val1 DWORD ?
val2 DWORD ?
val3 DWORD ?
val4 DWORD ?

.code
; 1. (val2 * val3) 곱셈 수행
mov  eax, val2       ; EAX = val2
mul  val3            ; EDX:EAX = EAX * val3 (32비트 Unsigned 곱셈)

; 2. (val4 - 3) 분모 계산
mov  ebx, val4       ; EBX = val4
sub  ebx, 3          ; EBX = val4 - 3

; 3. 나눗셈 및 결과 저장
div  ebx             ; EDX:EAX / EBX 연산 수행 (몫은 EAX에 저장됨)
mov  val1, eax       ; 몫(EAX)을 val1 변수에 저장
```

---

### **Problem (문제)**
> **12. Implement the following C++ expression in assembly language, using 32-bit signed operands:**  
> `val1 = (val2 / val3) * (val1 + val2)`  
> (32비트 부호 있는(Signed) 피연산자를 사용하여 C++ 수식 `val1 = (val2 / val3) * (val1 + val2)`를 어셈블리어로 구현하시오.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

1. **변수 타입**: 32비트 부호 있는 정수이므로 `.data` 영역에 **`SDWORD`** (또는 `DWORD`) 타입으로 변수를 선언합니다.
2. **부호 있는 나눗셈 (`val2 / val3`)**:
   * 부호 있는 나눗셈을 위해 **`idiv`** 명령어를 사용합니다.
   * `mov eax, val2` 실행 후, 나눗셈 전 **`cdq`** 명령어를 반드시 사용하여 `EAX`의 부호 비트를 `EDX`까지 확장(`EDX:EAX`)해 주어야 합니다.
   * `idiv val3` 연산 후 몫은 **`EAX`**에 저장됩니다.
3. **덧셈 연산 (`val1 + val2`)**:
   * `EBX` 레지스터에 `val1`을 복사한 뒤 `add ebx, val2`로 덧셈을 수행합니다.
4. **부호 있는 곱셈 연산 (`*`)**:
   * **`imul eax, ebx`** 명령어를 사용하여 나눗셈 몫(`EAX`)과 덧셈 결과(`EBX`)를 곱합니다.
5. **대입 연산 (`val1 = ...`)**:
   * 곱셈 결과가 들어있는 `EAX` 레지스터의 값을 `val1` 변수에 저장합니다.

---

### **정답 코드 (Answer Code)**

```assembly
.data
val1 SDWORD ?
val2 SDWORD ?
val3 SDWORD ?

.code
; 1. (val2 / val3) 나눗셈 수행
mov  eax, val2       ; EAX = val2
cdq                  ; EAX의 부호 비트를 EDX까지 64비트(EDX:EAX)로 확장
idiv val3            ; EAX = val2 / val3 (몫)

; 2. (val1 + val2) 덧셈 수행
mov  ebx, val1       ; EBX = val1
add  ebx, val2       ; EBX = val1 + val2

; 3. 두 결과 곱하기 및 val1에 대입
imul eax, ebx        ; EAX = EAX * EBX (Signed 곱셈)
mov  val1, eax       ; 결과를 val1 변수에 저장
```


---


### **Problem (문제)**
> **13. Write a procedure that displays an unsigned 8-bit binary value in decimal format. Pass the binary value in AL. The input range is limited to 0 to 99, decimal. The only procedure you can call from the book’s link library is WriteChar. The procedure should contain approximately eight instructions. Here is a sample call:**  
> ```assembly
> mov  al,65            ; range limit: 0 to 99 
> call showDecimal8
> ```  
> (`AL` 레지스터로 전달받은 8비트 부호 없는 이진수 값(범위: 0~99)을 10진수 형식으로 출력하는 `showDecimal8` 프로시저를 작성하시오. 사용할 수 있는 링크 라이브러리 함수는 `WriteChar`뿐이며, 약 8개의 명령어 내외로 작성해야 합니다.)

---

### **풀이 및 개념 정리 (Solution & Concept)**

1. **자리수 분리 (십의 자리 & 일의 자리)**:
   * 입력 범위가 `0`~`99`이므로 최대 두 자리 10진수입니다.
   * `AX`에 `AL` 값을 넣고 `10`으로 나누면:
     * **`AL` (몫)**: **십의 자리** 숫자
     * **`AH` (나머지)**: **일의 자리** 숫자
2. **ASCII 문자로 변환**:
   * 각 자릿수에 `'0'` ($30_{16}$)을 더해주면 출력이 가능한 ASCII 코드가 됩니다.
   * `add ax, 3030h` 명령어를 수행하면 `AH`와 `AL` 모두 한 번에 ASCII 문자로 변환됩니다.
3. **출력 순서**:
   * `WriteChar`는 **`AL` 레지스터에 저장된 ASCII 문자를 출력**합니다.
   * 따라서 먼저 **십의 자리(`AL`)**를 출력하고, 일의 자리(`AH`)를 `AL`로 옮긴 후 **일의 자리**를 출력합니다.

---

### **정답 코드 (Answer Code)**

```assembly
showDecimal8 PROC
    mov  ah, 0          ; AX = AL (피나눗수 형성: AH=0, AL=입력값)
    mov  bl, 10         ; 나눗수 10 설정
    div  bl             ; AL = 십의 자리(몫), AH = 일의 자리(나머지)
    add  ax, 3030h      ; AH와 AL을 각각 ASCII 문자로 변환 ('0'~'9')
    
    push ax             ; AH(일의 자리 문자)를 보존하기 위해 스택에 저장
    call WriteChar      ; 십의 자리(AL) 출력
    
    pop  ax             ; 스택에서 AH 복원
    mov  al, ah         ; 일의 자리 문자를 AL로 이동
    call WriteChar      ; 일의 자리(AL) 출력
    ret
showDecimal8 ENDP
```

---

### **단계별 명령어 설명 (Instruction Breakdown)**

1. `mov ah, 0`: `div` 연산을 위해 `AX`의 상위 바이트 `AH`를 0으로 초기화합니다.
2. `mov bl, 10`: 나누는 수 10을 `BL`에 대입합니다.
3. `div bl`: `AX`를 10으로 나눕니다. (`AL`=몫, `AH`=나머지)
4. `add ax, 3030h`: `AH`와 `AL` 각각에 `30h`('0'의 ASCII)를 한 번에 더합니다.
5. `push ax`: `WriteChar` 호출 시 `AL`이 훼손되거나 `AH`를 보존하기 위해 `AX` 전체를 스택에 저장합니다.
6. `call WriteChar`: `AL`에 담긴 십의 자리 ASCII 문자를 출력합니다.
7. `pop ax`: 스택에서 일의 자리 문자가 들어있는 `AH`를 복원합니다.
8. `mov al, ah`: 일의 자리 문자를 `WriteChar` 출력을 위해 `AL`로 옮깁니다.
9. `call WriteChar`: 일의 자리 ASCII 문자를 출력합니다.
10. `ret`: 프로시저를 종료하고 리턴합니다.


---

### **Problem (문제)**
> **Challenge: Suppose AX contains 0072h and the Auxiliary Carry flag is set as a result of adding two unknown ASCII decimal digits. Use the Intel 64 and IA-32 Instruction Set Reference to determine what output the AAA instruction would produce. Explain your answer.**  
> (`AX` 레지스터에 `0072h`가 들어있고, 두 알 수 없는 ASCII 10진수 숫자를 더한 결과로 보조 캐리 플래그(AF)가 `1`로 설정되었다고 가정합니다. Intel Instruction Set Reference를 참조하여 `AAA` 명령어 실행 후 `AX`에 생성되는 결과값을 구하고, 그 이유를 설명하시오.)

---

### **기본 개념: Intel 매뉴얼의 `AAA` 명령어 동작 정의**

Intel 64 및 IA-32 명령어 세트 참조 문서에 정의된 **`AAA` (ASCII Adjust After Addition)** 명령어의 의도 코드(Pseudocode)는 다음과 같습니다:

```text
IF ((AL AND 0FH) > 9) OR (AF = 1)
    THEN
        AL = (AL + 6) AND 0FH
        AH = AH + 1
        AF = 1
        CF = 1
    ELSE
        AF = 0
        CF = 0
        AL = AL AND 0FH
FI
```

---

### **단계별 풀이 및 분석 (Step-by-Step Analysis)**

1. **초기 레지스터 및 플래그 상태 확인**:
   * `AX` = `0072h` $\rightarrow$ **`AH` = `00h`**, **`AL` = `72h`**
   * **`AF` (Auxiliary Carry Flag) = `1`**

2. **조건식 평가**:
   * 조건: `((AL AND 0FH) > 9) OR (AF = 1)`
   * `AL AND 0FH` = `72h AND 0Fh` = **`02h`** ($2 \le 9$ 이므로 거짓)
   * 그러나 문제 조건에서 **`AF = 1`**이 주어진 상태이므로 `OR` 조건에 의해 **조건식 전체가 참(TRUE)**이 됩니다.

3. **`THEN` 블록 실행**:
   * **`AL` 값 조정**:
     $$\text{AL} \leftarrow (\text{AL} + 6) \text{ AND } 0\text{Fh}$$
     $$\text{AL} \leftarrow (72\text{h} + 6) \text{ AND } 0\text{Fh} = 78\text{h} \text{ AND } 0\text{Fh} = \mathbf{08\text{h}}$$
   * **`AH` 값 증가**:
     $$\text{AH} \leftarrow \text{AH} + 1 = 00\text{h} + 1 = \mathbf{01\text{h}}$$
   * **플래그 설정**:
     $$\text{AF} = 1, \quad \text{CF} = 1$$

4. **최종 결과**:
   * `AH` = `01h`, `AL` = `08h`
   * 따라서 **`AX` = `0108h`**

---

### **최종 정답 요약 (Summary)**

* **`AX` 의 출력 결과**: **`0108h`**
* **설명 요약**:  
  `AL` 하위 4비트(`2`) 자체는 9 이하이지만, 보조 캐리 플래그(`AF = 1`)가 설정되어 있으므로 `AAA` 명령어의 보정 조건이 활성화됩니다. 이에 따라 `AL`에 6을 더한 뒤 하위 4비트만 남겨 `AL = 08h`가 되고, 올림수(Carry)가 상위 바이트로 전달되어 `AH = 01h`가 됩니다. 결과적으로 `AX`에는 언팩(Unpacked) BCD 형식인 **`0108h`**가 저장됩니다.

---

### **Problem (문제)**
> **15. Challenge: Using only SUB, MOV, and AND instructions, show how to calculate x = n mod y, assuming that you are given the values of n and y. You can assume that n is any 32-bit unsigned integer, and y is a power of 2.**  
> (`SUB`, `MOV`, `AND` 명령어만을 사용하여 $x = n \bmod y$ 를 계산하는 코드를 작성하시오. 단, $n$과 $y$의 값이 주어졌다고 가정하며, $n$은 임의의 32비트 부호 없는 정수이고 $y$는 $2$의 거듭제곱($2^k$) 형태입니다.)

---

### **핵심 수학적 원리 (Mathematical Concept)**

* 어떤 수 $y$가 **$2$의 거듭제곱 ($y = 2^k$)**일 때, $n \bmod y$ 연산은 **$n$의 비트 중 하위 $k$비트만 남기는 비트 마스킹(Bit Masking)** 연산과 수학적으로 완전히 동일합니다:
  $$n \bmod 2^k = n \text{ AND } (2^k - 1) = n \text{ AND } (y - 1)$$

* 예를 들어, $y = 8$ ($2^3$) 이면 $y - 1 = 7$ ($0000\,0111_2$) 이며, 하위 3개 비트만 `1`로 채워진 마스크(Mask)가 만들어집니다.

---

### **정답 코드 (Answer Code)**

```assembly
; 입력: EAX = n (32비트 정수), EBX = y (2의 거듭제곱 값)
; 출력: EAX = x (n mod y 연산 결과)

mov ecx, ebx        ; ECX 레지스터에 y 값을 복사
sub ecx, 1          ; ECX = y - 1 (하위 k비트가 1인 비트 마스크 생성)
and eax, ecx        ; EAX = n AND (y - 1) 연산으로 n mod y 계산
```

---

### **작동 과정을 예시로 검증 (Example Verification)**

* **조건**: $n = 37$, $y = 8$ ($2^3$)
* **목표 계산**: $37 \bmod 8 = \mathbf{5}$

1. **`mov ecx, ebx`**:
   * `ECX` = $8$ (`0000 0000 0000 0000 0000 0000 0000 1000b`)
2. **`sub ecx, 1`**:
   * `ECX` = $8 - 1 = 7$ (`0000 0000 0000 0000 0000 0000 0000 0111b`)
3. **`and eax, ecx`**:
   * `EAX` ($37$) = `0000 0000 0000 0000 0000 0000 0010 0101b`
   * `ECX` ($7$)  = `0000 0000 0000 0000 0000 0000 0000 0111b`
   * `AND` 연산 결과 = `0000 0000 0000 0000 0000 0000 0000 0101b` = **$5$**

---

### **제약 조건 충족 확인**
* 사용된 명령어: **`MOV`**, **`SUB`**, **`AND`** (허용된 3가지 명령어만 정확히 사용함)

---

### **Problem (문제)**
> **16. Challenge: Using only SAR, ADD, and XOR instructions (but no conditional jumps), write code that calculates the absolute value of the signed integer in the EAX register.**  
> *(Hints: A number can be negated by adding 1 to it and then forming its one’s complement. Also, if you XOR an integer with all 1s, its 1s are reversed. On the other hand, if you XOR an integer with all zeros, the integer is unchanged.)*  
> (`SAR`, `ADD`, `XOR` 명령어만 사용하여(조건 분기문 없이) `EAX` 레지스터에 있는 부호 있는 정수의 절대값 $|EAX|$을 구하는 코드를 작성하시오.)

---

### **핵심 수학적 원리 (Mathematical Concept)**

1. **부호 반전(Negation)의 또 다른 공식**:
   * 일반적으로 $2$의 보수 관계에 의해 $-x = \sim x + 1$ (1의 보수 + 1) 입니다.
   * 양변에서 $1$을 빼면, **$-x = \sim(x - 1)$** 즉, **"수에서 $1$을 뺀 뒤 비트 반전(1의 보수)을 취하면 부호가 반전"**됩니다.

2. **비트 마스크(Bit Mask) 형성**:
   * `sar ebx, 31`을 실행하면 `EAX`가 **양수/0**일 때는 `EBX = 00000000h` ($0$), **음수**일 때는 `EBX = FFFFFFFFh` ($-1$, 모든 비트가 `1`)가 됩니다.
   * `XOR` 연산의 특성:
     * 어떤 수 $N \text{ XOR } 0 = N$ (변화 없음)
     * 어떤 수 $N \text{ XOR } \text{FFFFFFFFh} = \sim N$ (1의 보수 / 모든 비트 반전)

3. **공식 결합**:
   $$\text{Result} = (EAX + mask) \oplus mask$$
   * **$EAX \ge 0$ (양수/0)**: $(EAX + 0) \oplus 0 = EAX$ (원래 값 유지)
   * **$EAX < 0$ (음수)**: $(EAX + (-1)) \oplus \text{FFFFFFFFh} = \sim(EAX - 1) = -EAX = |EAX|$ (부호 반전되어 양수로 변환)

---

### **정답 코드 (Answer Code)**

```assembly
mov ebx, eax    ; EAX의 값을 EBX에 복사 (부호 마스크 생성용)
sar ebx, 31     ; EAX가 양수/0이면 EBX = 0, 음수이면 EBX = -1 (모든 비트 1)
add eax, ebx    ; EAX가 음수면 1을 뺌 (EAX = EAX - 1), 양수면 0을 더함
xor eax, ebx    ; EAX가 음수면 비트 반전(~(EAX-1) = -EAX), 양수면 변화 없음
```

---

### **작동 과정을 예시로 검증 (Example Verification)**

#### **1) $EAX = -5$ (음수) 인 경우**
* **`sar ebx, 31`**: `EBX = FFFFFFFFh` ($-1$)
* **`add eax, ebx`**: `EAX` = $-5 + (-1) = -6$ (`1111 1010b`)
* **`xor eax, ebx`**: `EAX` = $-6 \text{ XOR } \text{FFFFFFFFh} = \sim(-6) = \mathbf{+5}$  
  $\rightarrow$ **음수가 절대값 $+5$로 변환됨!**

#### **2) $EAX = +5$ (양수) 인 경우**
* **`sar ebx, 31`**: `EBX = 00000000h` ($0$)
* **`add eax, ebx`**: `EAX` = $+5 + 0 = +5$
* **`xor eax, ebx`**: `EAX` = $+5 \text{ XOR } 0 = \mathbf{+5}$  
  $\rightarrow$ **양수는 $+5$ 그대로 유지됨!**

---

### **최종 정답 요약 (Summary)**

* **비분기(Branchless) 절대값 산출 알고리즘**을 통해 CPU의 캐시 미스나 점프 예측 실패 없이 속도가 가장 빠르게 절대값을 구할 수 있는 x86 어셈블리 기법입니다.

---



