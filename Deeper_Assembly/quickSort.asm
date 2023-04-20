;; In this file, you must implement the 'quicksort' and 'partition' subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'quicksort' or 'partition' label.


;; Pseudocode:

;; Partition

;;    partition(int[] arr, int low, int high) {
;;        int pivot = arr[high];
;;        int i = low - 1;
;;        for (j = low; j < high; j++) {
;;            if (arr[j] < pivot) {
;;                i++;
;;                int temp = arr[j];
;;                arr[j] = arr[i];
;;                arr[i] = temp;
;;            }
;;        }
;;        int temp = arr[high];
;;        arr[high] = arr[i + 1];
;;        arr[i + 1] = temp;
;;        return i + 1;
;;    }
        
;; Quicksort

;;    quicksort(int[] arr, int left, int right) {
;;        if (left < right) {
;;            int pi = partition(arr, left, right);
;;            quicksort(arr, left, pi - 1);
;;            quicksort(arr, pi + 1, right);
;;        }
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

partition   ;; please do not change the name of your subroutine
    
    ADD R6, R6, #-4     ; Allocate Space
    STR R7, R6, #2      ; Store return address
    STR R5, R6, #1      ; Store old frame pointer
    ADD R5, R6, #0      ; Set R5 as stack pointer

    ADD R6, R6, #-7     ; Save registers
    STR R0, R6, #0	
	STR R1, R6, #1	
	STR R2, R6, #2	
	STR R3, R6, #3	
	STR R4, R6, #4	

    LDR R0, R5, #6      ; R0 = high
    LDR R1, R5, #5      ; R1 = low
    LDR R2, R5, #4      
    ADD R2, R2, R0      
    LDR R2, R2, #0      ; R2 = pivot = value of arr[high]
    STR R2, R5, #0      ; Store 'pivot' in R5

    ADD R3, R1, #-1     ; R3 = i = low - 1
    STR R3, R5, #-1     ; Store 'i' in 'R5-1'
    ADD R4, R1, 0       ; R4 = j (=low)

FOR 

    LDR R0, R5, #6      ; R0 = high
    LDR R1, R5, #5      ; R1 = low
    LDR R2, R5, #4      
    ADD R2, R2, R0      
    LDR R2, R2, #0      ; R2 = pivot = value of arr[high]

    NOT R0, R0
    ADD R0, R0, 1       ; R0 = -high
    ADD R0, R0, R4      ; R0 = j - high
    BRzp EF

    LDR R1, R5, #4      
    ADD R1, R1, R4
    LDR R1, R1, 0       ; R1 = value of arr[j]

    NOT R0, R2
    ADD R0, R0, 1       ; R0 = -pivot
    ADD R0, R1, R0      ; R0 = arr[j] - pivot
    BRzp EI

    ADD R3, R3, 1       ; i++
    STR R3, R5, #-1     ; Store 'i' into 'R5 - 1'

    AND R0, R0, 0       ; Reset R0
    ADD R0, R1, 0       ; R0 -> temp = value of arr[j]
    STR R0, R5, #-2     ; Store 'temp' in 'R5-2'
    
    LDR R1, R5, #4
    ADD R1, R1, R3
    LDR R1, R1, 0       ; R1 = value of arr[i]

    LDR R2, R5, #4      
    ADD R2, R2, R4      ; R2 = address of arr[j]
    STR R1, R2, 0       ; arr[j] = arr[i]

    LDR R1, R5, #4 
    ADD R1, R1, R3      ; R1 = address of arr[i]
    STR R0, R1, 0       ; arr[i] = temp 
    BR EI

EI  
    ADD R4, R4, 1       ; R4 -> j++
    BR FOR

EF  
    LDR R2, R5, #6      ; R2 = high
    LDR R4, R5, #4      ; R4 = address of arr[]
    
    ADD R3, R3, 1       ; i = i + 1
    ADD R1, R4, R3      ; R1 = address of arr[i + 1]
    LDR R1, R1, 0       ; R1 = value of arr[i + 1]

    ADD R4, R4, R2      ; R4 = address of arr[high]
    LDR R0, R4, 0       ; R0 = temp -> value of arr[high]
    STR R0, R5, #-2     ; Store 'temp' in 'R5-2'

    STR R1, R4, 0       ; R4 : arr[high] = arr[i + 1]

    LDR R4, R5, #4
    ADD R1, R3, R4      ; R1 = address of arr[i + 1]
    STR R0, R1, 0       ; R1 : arr[i + 1] = temp

    STR R3, R5, 3

    LDR R0, R6, 0       ; Tear-down
    LDR R1, R6, 1
    LDR R2, R6, 2
    LDR R3, R6, 3
    LDR R4, R6, 4

    ADD R6, R6, X
    
    LDR R5, R6, 1
    LDR R7, R6, 2
    ADD R6, R6, 3

    RET

quicksort   ;; please do not change the name of your subroutine
    
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

    LDR R0, R5, #6      ; R0 = right
    LDR R1, R5, #5      ; R1 = left
    LDR R2, R5, #4      ; R2 = address of arr

IF  
    NOT R3, R0
    ADD R3, R3, 1       ; R3 = -right
    ADD R3, R3, R1      ; R3 = left - right
    BRzp EIF

    ADD R6, R6, #-1     ; Space for right in (arr,left,right)
    STR R0, R6, 0       ; Store the value of right
    ADD R6, R6, #-1     ; Space for left in (arr, left, right)
    STR R1, R6, 0       ; Store the value of left
    ADD R6, R6, #-1     ; Space for arr in (arr, left, right)
    STR R2, R6, 0       ; Store the address of arr

    JSR partition

    LDR R4, R6, 0       ; R4 = pi (=Receive the result from partition)
    STR R4, R5, 0       ; Store pi in R5
    ADD R6, R6, 4       ; Come back and point R0 (= pop)

    ADD R6, R6, #-1     ; Space for 'pi - 1' in (arr,left,pi - 1)
    ADD R3, R4, #-1     ; R3 = pi - 1
    STR R3, R6, 0       ; Store the value of "pi - 1"
    ADD R6, R6, #-1     ; Space for left in (arr, left, pi - 1)
    STR R1, R6, 0       ; Store the value of left
    ADD R6, R6, #-1     ; Space for arr in (arr, left, pi - 1)
    STR R2, R6, 0       ; Store the address of arr    

    JSR quicksort
    ADD R6, R6, 4       ; Come back and point R0 (= pop)

    ADD R6, R6, #-1     ; Space for right in (arr,pi + 1,right)
    STR R0, R6, 0       ; Store the value of right
    ADD R6, R6, #-1     ; Space for left in (arr, pi + 1, right)
    ADD R3, R4, 1       ; R3 = pi + 1
    STR R3, R6, 0       ; Store the value of "pi + 1"
    ADD R6, R6, #-1     ; Space for arr in (arr, left, right)
    STR R2, R6, 0       ; Store the address of arr

    JSR quicksort
    ADD R6, R6, 4       ; Come back and point R0 (= pop)
    BR EIF
    
EIF

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


;; Assuming the array starts at address x4000, here's how the array [1,3,2,5] represents in memory
;; Memory address           Data
;; x4000                    1
;; x4001                    3
;; x4002                    2
;; x4003                    5