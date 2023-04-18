;; Pseudocode (see PDF for explanation)
;;
;; int count = 0;
;; int chars = 0;
;; int i = 0;
;;
;;  while(str[i] != '\0') {
;;      if (str[i] != ' ') 
;;          chars++;
;;      
;;      else {
;;          if (chars == 4) 
;;              count++;   
;;          chars = 0;
;;      }
;;      i++;
;;  }
;; ***IMPORTANT***
;; - Assume that all strings provided will end with a space (' ').
;; - Special characters do not have to be treated differently. For instance, strings like "it's" and "But," are considered 4 character strings.
;;

.orig x3000
	
	AND R0, R0, #0		; R0 = count
	AND R1, R1, #0		; R1 = chars
	AND R2, R2, #0		; R2 = i
	LD R3, STRING		; R3 = string

W1 	ADD R4, R3, R2		; R3 = address of string[i]
	LDR R4, R4, #0		; R4 = value of string[i]
	BRz EN1				; if (str[i] == 0), go to EN1

	ADD R5, R4, #-16	
	ADD R5, R5, #-16	; R5 = str[i] - ' '
	BRz	EL1				; if (R4 == 0), go to EL1
	ADD R1, R1, #1		; chars++
	BR GO1				

EL1
	ADD R1, R1, #-4		; chars = chars - 4
	BRz ZE1				; if (chars - 4 == 0), go to ZE1
	AND R1, R1, #0		; chars = 0
	BR GO1

ZE1
	ADD R0, R0, #1		; count++
	AND R1, R1, #0		; chars = 0
	BR GO1
	
GO1
	ADD R2, R2, #1		; i = i + 1
	BR W1

EN1	
	ST R0, ANSWER		; mem[ANSWER] = R0 = count
	HALT


SPACE 	.fill #-32
STRING	.fill x4000
ANSWER .blkw 1

.end


.orig x4000

.stringz "I love CS 2110 and assembly is very fun! "

.end
