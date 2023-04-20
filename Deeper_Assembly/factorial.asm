;; In this file, you must implement the 'factorial' and "mult" subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'factorial' or 'mult' label.

;; Pseudocode

;; Factorial

;;    factorial(int n) {
;;        int ret = 1;
;;        for (int x = 2; x < n+1; x++) {
;;            ret = mult(ret, x);
;;        }
;;        return ret;
;;    }

;; Multiply
         
;;    mult(int a, int b) {
;;        int ret = 0;
;;        int copyB = b;
;;        while (copyB > 0):
;;            ret += a;
;;            copyB--;
;;        return ret;
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

factorial   ;; please do not change the name of your subroutine

    ADD R6, R6, #-4     ; Allocate Space
    STR R7, R6, #2      ; Store return address
    STR R5, R6, #1      ; Store old frame pointer
    ADD R5, R6, #0      ; Set R5 as stack pointer

    ADD R6, R6, #-5     ; Save registers
    STR R0, R6, #0	
	STR R1, R6, #1	
	STR R2, R6, #2	
	STR R3, R6, #3	
	STR R4, R6, #4	

    LDR R0, R5, #4       ; R0 = n (Loading)
    
    AND R1, R1, #0       
    ADD R1, R1, #1       ; R1 = ret = 1 
    STR R1, R5, #0       ; Store 'ret' in R5
    AND R2, R2, #0
    ADD R2, R2, #2       ; R2 = x = 2

FOR 
    NOT R3, R2 
    ADD R3, R3, 1       ; R3 = -x
    ADD R3, R3, R0      ; R3 = n - x
    ADD R3, R3, 1       ; R3 = n + 1 - x
    BRnz EF

    ADD R6, R6, #-1     ; Make a space for x in (ret, x)
    STR R2, R6, 0       ; Store the value of x
    ADD R6, R6, #-1     ; Make another space for ret in (ret, x)
    STR R1, R6, 0       ; Store the value of ret
    
    JSR	 mult           ; Send it to mult

    LDR R1, R6, 0       ; R1 -> ret = mult(ret, x)
    ADD R6, R6, 3       ; Come back and point R0 (= pop arguments)
    ADD R2, R2, 1       ; x++
    BR FOR

EF
    STR R1, R5, 3       ; Store the result value on R5
  
    LDR R0, R6, 0       ; Tear-down
    LDR R1, R6, 1
    LDR R2, R6, 2
    LDR R3, R6, 3
    LDR R4, R6, 4
    ADD R6, R6, 5

    LDR R5, R6, 1
    LDR R7, R6, 2
    ADD R6, R6, 3

    RET
    
mult        ;; please do not change the name of your subroutine
    
    ADD R6, R6, #-4     ; Allocate Space
    STR R7, R6, #2      ; Store return address
    STR R5, R6, #1      ; Store old frame pointer
    ADD R5, R6, #0      ; Set R5 as stack pointer

    ADD R6, R6, #-5     ; Save registers
    STR R0, R6, #0	
	STR R1, R6, #1	
	STR R2, R6, #2	
	STR R3, R6, #3	
	STR R4, R6, #4	

    LDR R1, R5, #4      ; R1 = a (Loading)
    LDR R0, R5, #5      ; R0 = b (Loading)
    
    AND R2, R2, 0       ; R2 = ret = 0
    AND R3, R3, 0
    ADD R3, R3, R0      ; R3 = copyB = b

WH  ADD R3, R3, 0
    BRnz WE             ; if (copyB <= 0), go to WE

    ADD R2, R2, R1      ; ret = ret + a
    ADD R3, R3, #-1     ; copyB = copyB - 1
    BR WH

WE
 
    STR R2, R5, 3       ; Store the result value on R5
  
    LDR R0, R6, 0       ; Tear-down (Restore registers)
    LDR R1, R6, 1
    LDR R2, R6, 2
    LDR R3, R6, 3
    LDR R4, R6, 4
    
    ADD R6, R6, 5       ; Restore return address & frame pointer
    LDR R5, R6, 1
    LDR R7, R6, 2
    ADD R6, R6, 3

    RET

STACK .fill xF000
.end
