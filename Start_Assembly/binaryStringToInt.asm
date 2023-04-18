;; Pseudocode (see PDF for explanation)
;;
;;    int result = x4000; (given memory address to save the converted value)
;;    String binaryString= "01000000"; (given binary string)
;;    int length = 8; (given length of the above binary string)
;;    int base = 1;
;;    int value = 0;
;;    while (length > 0) {
;;        int y = binaryString.charAt(length - 1) - 48;
;;        if (y == 1) {
;;            value += base;
;;        }     
;;            base += base;
;;            length--;
;;    }
;;    mem[result] = value;


.orig x3000
    
    LD R0, binaryString     ; R0 = address of binaryString
    LD R1, length           ; R1 = length
    AND R2, R2, #0          ; R2 = value = 0
    AND R3, R3, #0
    ADD R3, R3, #1          ; R3 = base = 1

W1  ADD R1, R1, #0
    BRnz EN1                ; if (length <= 0), go to EN1

    ADD R4, R0, R1          ; R4 = address of binaryString[length]
    ADD R4, R4, #-1         ; R4 = address of binaryString[length -1]
    LDR R4, R4, #0          ; R4 = value of binaryString[length -1]
    ADD R4, R4, #-16        
    ADD R4, R4, #-16
    ADD R4, R4, #-16        ; R4 = binaryString[length -1] - 48
    BRnz EI1
    ADD R2, R2, R3          ; value = value + base
    BR GO1

EI1 GO1

GO1 ADD R3, R3, R3          ; base = base + base
    ADD R1, R1, #-1         ; length = length - 1
    BR W1

EN1 
    LD R5, result           ; R5 = address of result
    STR R2, R5, #0          ; STR --> store the data in 'result' address

    HALT

    binaryString .fill x5000
    length .fill 8
    result .fill x4000
.end 

.orig x5000
    .stringz "01100001"
.end
