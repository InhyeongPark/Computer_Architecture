#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include "my_malloc.h"

metadata_t *address_list;
enum my_malloc_err my_malloc_errno;


unsigned long returnSize (metadata_t *curr) {
    return (curr->size + TOTAL_METADATA_SIZE);
}

static metadata_t *find_right(metadata_t *freed_block) {
    metadata_t *curr = address_list;
    if (!curr || !(curr->next) || !freed_block) {
        return NULL;
    } else if ((char*) freed_block + returnSize(freed_block) == (char*) freed_block->next) {
        return freed_block->next;
    }
    return NULL;
}

static metadata_t *find_left(metadata_t *freed_block) {
    metadata_t *curr = address_list;

    while (curr && ((uintptr_t) freed_block > (uintptr_t) curr)) {
        if ((uintptr_t) ((uint8_t*) (curr + 1) + curr->size) == (uintptr_t) freed_block) {
            return curr;
        }
        curr = curr->next;
    }
    
    return NULL;
}

static void merge(metadata_t *left, metadata_t *right) {
    left->size += returnSize(right);
    left->next = right->next;
}

static metadata_t *split_block(metadata_t *block, size_t size) {
    metadata_t *currBlock = (metadata_t*) ((char*) block + block->size - size);
    currBlock->size = size;
    block->size -= size + TOTAL_METADATA_SIZE;
    return currBlock;
}

static void add_to_addr_list(metadata_t *block) {
    if (!block) {
        return;
    }
    
    if (!address_list) {
        block->next = NULL;
        address_list = block;
        return;
    }
    
    if (address_list > block) {
        block->next = address_list;
        address_list = block;
        return;
    }

    metadata_t *curr = address_list;
    while ((curr->next) && (curr->next < block)) {
        curr = curr->next;
    }
    block->next = curr->next;
    curr->next = block;
}

static void remove_from_addr_list(metadata_t *block) {
    metadata_t *curr = address_list;
    if (!curr) {
        return;
    } else if (curr == block) {
        address_list = curr->next;
    }

    metadata_t *next;
    while ((next = curr->next) && (uintptr_t) block > (uintptr_t) next) {
        curr = next;
    }
    if (next == block) {
        curr->next = next->next;
    }
}

static metadata_t *find_best_fit(size_t size) {
    metadata_t *curr = address_list;
    metadata_t *temp = NULL;
    while (curr) {
        if (curr -> size == size) {
            remove_from_addr_list(curr);
            return curr;
        }

        if ((curr->size > size && !temp) || (temp && (curr->size > size) && (curr->size < temp->size))) {
            temp = curr;
        }

        curr = curr->next;
    }

    if (!temp) {
        return NULL;
    }

    if (temp->size < size + MIN_BLOCK_SIZE) {
        remove_from_addr_list(temp);
        return temp;
    } else {
        return split_block(temp, size);
    }
}

void *my_malloc(size_t size) {
    my_malloc_errno = NO_ERROR;
    
    if (size == 0) {
        return NULL;
    }

    size_t currSize = size + TOTAL_METADATA_SIZE;
    if (currSize > SBRK_SIZE) {
        my_malloc_errno = SINGLE_REQUEST_TOO_LARGE;
        return NULL;
    }

    metadata_t *fit = find_best_fit(size);
    if (!fit || fit->size < size) {
        void *temp = my_sbrk(SBRK_SIZE);
        if (temp == (void*) -1) {
            my_malloc_errno = OUT_OF_MEMORY;
            return NULL;
        }

        metadata_t *curr = (metadata_t *) temp;
        curr->size = SBRK_SIZE - TOTAL_METADATA_SIZE;
        curr->next = NULL;
        add_to_addr_list(curr);

        metadata_t *left = find_left(curr);
        if (left) {
            left->next = curr->next;
            left->size = returnSize(left) + curr->size;
        }
        return my_malloc(size);
    }

    if (fit->size == size || fit->size < size + MIN_BLOCK_SIZE) {
        remove_from_addr_list(fit);
        return ((uint8_t*)fit + TOTAL_METADATA_SIZE); // Malloc should return (uint8_t) -> malloc_suite
    }

    metadata_t *newData = ((metadata_t*)((uint8_t*)fit + returnSize(fit) - currSize));
    newData->size = size;
    newData->next = NULL;
    fit->size -= currSize;
    return ((uint8_t*)newData + TOTAL_METADATA_SIZE);
}

void my_free(void *ptr) {
    my_malloc_errno = NO_ERROR;
    if (!ptr) {
        return;
    }
    metadata_t *temp = (metadata_t*)((uint8_t*)ptr - TOTAL_METADATA_SIZE);
    add_to_addr_list(temp);
    metadata_t *rightPtr = find_right(temp);
    if (rightPtr) {
        merge(temp, rightPtr);
    }
    metadata_t *leftPtr = find_left(temp);
    if (leftPtr) {
        merge(leftPtr, temp);
    }
}

void *my_realloc(void *ptr, size_t size) {
    my_malloc_errno = NO_ERROR;
    
    if(!ptr) {
        return my_malloc(size);
    } else if (size == 0) {
        my_free(ptr);
        return NULL;
    }

    size_t currSize;
    if (((metadata_t*)ptr)->size > size) {
        currSize = size;
    } else {
        currSize = ((metadata_t*)ptr)->size;
    }

    void* newData = my_malloc(size);
    if (!newData) {
        //my_malloc_errno = OUT_OF_MEMORY;
        return NULL;
    }
    
    memcpy(newData, ptr, currSize);
    
    if (newData) {
        my_free(ptr);
    }
    
    return newData;
}

void *my_calloc(size_t nmemb, size_t size) {
    my_malloc_errno = NO_ERROR;

    void *newData = my_malloc(nmemb * size);
    if (!newData) {
        return NULL;
    } else {
        memset(newData, 0, nmemb * size);
        return newData;
    }
}
