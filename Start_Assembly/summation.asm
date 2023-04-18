;; Pseudocode (see PDF for explanation)
;;
;;    int result; (to save the summation of x)
;;    int x= -9; (given integer)
;;    int answer = 0;
;;    while (x > 0) {
;;        answer += x;
;;        x--;
;;    }
;;    result = answer;

.orig x3000
    
    LD R1, x            ; R1 = x
    AND R2, R2, #0      ; R2 = answer = 0

W1  ADD R1, R1, #0
    BRnz ENDW1       ; if (x <= 0) break out the loop
    ADD R2, R2, R1   ; answer += x
    ADD R1, R1, #-1  ; x--
    BR W1

ENDW1
   ST R2, result

HALT

    x .fill -9
    result .blkw 1

.end

