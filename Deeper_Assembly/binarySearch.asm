;; In this file, you must implement the 'binarySearch' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'binarySearch' label.


;; Pseudocode:

;; Nodes are blocks of size 3 in memory:

;; The data is located in the 1st memory location
;; The node's left child address is located in the 2nd memory location
;; The node's right child address is located in the 3rd memory location

;; Binary Search

;;    binarySearch(Node root (addr), int data) {
;;        if (root == 0) {
;;            return 0;
;;        }
;;        if (data == root.data) {
;;            return root;
;;        }
;;        if (data < root.data) {
;;            return binarySearch(root.left, data);
;;        }
;;        return binarySearch(root.right, data);
;;    }

.orig x3000
    ;; you do not need to write anything here
HALT

binary_search   ;; please do not change the name of your subroutine
    
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

    LDR R0, R5, #4      ; R0 = root
    LDR R1, R5, #5      ; R1 = data

    ADD R0, R0, 0
    BRz IF1

    NOT R2, R1
    ADD R2, R2, 1       ; R2 = - data
    LDR R3, R0, 0       ; R3 = root.data
    ADD R3, R3, R2      ; R3 = root.data - data
    BRz IF2

    ADD R3, R3, 0       ; R3 = root.data - data
    BRp IF3

    ADD R6, R6, #-1     ; Make space for 'data' in (root.right, data)
    STR R1, R6, 0       ; Store value of 'data'

    ADD R6, R6, #-1     ; Make another space for 'root.right'
    LDR R0, R0, 2       ; R0 = root + 2 -> root.right
    STR R0, R6, 0       ; Store address of root.right
    
    JSR binary_search

    LDR R4, R6, 0       ; R4 -> value of binarySearch(root.right, data)
    ADD R6, R6, 3       ; Come back (= pop)
    STR R4, R5, 3       ; return R4
    BR TEARDOWN

IF1 
    AND R2, R2, 0       
    STR R2, R5, 3       ; return 0
    BR TEARDOWN

IF2 
    STR R0, R5, 3       ; return root
    BR TEARDOWN

IF3

    ADD R6, R6, #-1     ; Make space for data in (root.left, data)
    STR R1, R6, 0       ; Store value of data

    ADD R6, R6, #-1     ; Make another space for root.left
    LDR R0, R0, 1       ; R0 = root + 1 -> address of root.left
    STR R0, R6, 0       ; Store value of root.left
    
    JSR binary_search

    LDR R4, R6, 0       ; R4 -> value of binarySearch(root.left, data)
    ADD R6, R6, 3       ; Come back (= pop)
    STR R4, R5, 3       ; return R4
    BR TEARDOWN

TEARDOWN

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
STACK .fill xF000
.end

;; Assuming the tree starts at address x4000, here's how the tree (see below and in the pdf) represents in memory
;;
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 
;;
;; Memory address           Data
;; x4000                    4
;; x4001                    x4004
;; x4002                    x4008
;; x4003                    Don't Know
;; x4004                    2
;; x4005                    x400C
;; x4006                    x4010
;; x4007                    Don't Know
;; x4008                    8
;; x4009                    0(NULL)
;; x400A                    0(NULL)
;; x400B                    Don't Know
;; x400C                    1
;; x400D                    0(NULL)
;; x400E                    0(NULL)
;; x400F                    Dont't Know
;; x4010                    3
;; x4011                    0(NULL)
;; x4012                    0(NULL)
;; x4013                    Dont't Know
;;
;; *note: 0 is equivalent to NULL in assembly