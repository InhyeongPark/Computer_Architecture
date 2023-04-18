;; Pseudocode (see PDF for explanation)
;;
;;	int A[] = {1,2,3};
;;	int B[] = {-1, 7, 8};
;;	int C[3];
;;
;;	int i = 0;
;;
;;	while (i < A.length) {
;;		if (A[i] < B[i])
;;			C[i] = B[i];
;;		else
;;			C[i] = A[i];
;;
;;		i += 1;
;;	}


.orig x3000
	
	AND R0, R0, #0		; R0 = i

W1	LD R1, LEN			; R1 = LEN
	NOT R1, R1
	ADD R1, R1, #1	
	ADD R1, R0, R1		; R1 = i - LEN
	BRzp ENDW			; if (i - LEN >= 0), go to ENDW

	LD R2, A			; R2 = address of A
	ADD R2, R2, R0		; R2 = address of A[i]
	LDR R2, R2, #0		; R2 = value of A[i]
	
	LD R3, B			; R3 = address of B
	ADD R3, R3, R0		; R3 = address of B[i]
	LDR R3, R3, #0		; R3 = value of B[i]

	NOT R4, R3			; R4 = ~ B[i]
	ADD R4, R4, #1		; R4 = - B[i]
	ADD R4, R4, R2      ; R4 = A[i] - B[i]
	BRzp EL1			; if (A[i] - B[i] >= 0), go to EL1

	LD R5, C			; R5 = address of C
	ADD R5, R5, R0		; R5 = address of C[i]
	STR R3, R5, #0		; Store B[i] to C[i]
	BR EN 				; Go to EN

EL1 
    LD R6, C			; R6 = address of C
    ADD R6, R6, R0		; R6 = address of C[i]
	STR R2, R6, #0		; Store A[i] to C[i]
	BR EN 				; Go to EN

EN 
    ADD R0, R0, #1		; R0 += 1
	BR W1 				; Return to W1

ENDW HALT


A 	.fill x3200
B 	.fill x3300
C 	.fill x3400
LEN .fill 4

.end

.orig x3200
	.fill -1
	.fill 2
	.fill 7
	.fill -3
.end

.orig x3300
	.fill 3
	.fill 6
	.fill 0
	.fill 5
.end

.orig x3400
	.blkw 4
.end


