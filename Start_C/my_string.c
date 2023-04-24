#include <stddef.h>
#include "animal.h"

/**
 * @brief Calculate the length of a string
 *
 * @param s a constant C string
 * @return size_t the number of characters in the passed in string
 */
size_t my_strlen(const char *s)
{
  /* Note about UNUSED_PARAM
   *
   * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
   * parameters prior to implementing the function. Once you begin implementing this
   * function, you can delete the UNUSED_PARAM lines.
   */

  if (*s != '\0') {
    // return (sizeof(s) / sizeof(char));  --> Would this work?
    size_t len = 0;
    while (*(s + len) != '\0') {
      len++;
    }
    return len;
  }
  return 0;
}

/**
 * @brief Compare two strings
 *
 * @param s1 First string to be compared
 * @param s2 Second string to be compared
 * @param n First (at most) n bytes to be compared
 * @return int "less than, equal to, or greater than zero if s1 (or the first n
 * bytes thereof) is found, respectively, to be less than, to match, or be
 * greater than s2"
 */
int my_strncmp(const char *s1, const char *s2, size_t n)
{
  /* Note about UNUSED_PARAM
   *
   * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
   * parameters prior to implementing the function. Once you begin implementing this
   * function, you can delete the UNUSED_PARAM lines.
   */
  size_t len = 0;
  while (*(s1 + len) != '\0' && *(s2 + len) != '\0') {
    if (len > n) {
      return 0;
    }
    if (*(s1 + len) > *(s2 + len)) return 1;
    else if (*(s1 + len) < *(s2 + len)) return (-1);
    len++;
  }
  if (*(s1 + len) == '\0' && *(s2 + len) == '\0') return 0;
  else if (*(s1 + len) != '\0') return 1;
  else return (-1);
}

/**
 * @brief Copy a string
 *
 * @param dest The destination buffer
 * @param src The source to copy from
 * @param n maximum number of bytes to copy
 * @return char* a pointer same as dest
 */
char *my_strncpy(char *dest, const char *src, size_t n)
{
  /* Note about UNUSED_PARAM
   *
   * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
   * parameters prior to implementing the function. Once you begin implementing this
   * function, you can delete the UNUSED_PARAM lines.
   */
  size_t countLen = my_strlen(src);
  size_t i = 0;
  if (countLen <= n) {
    for (i = 0; i < countLen; i++) {
      *(dest + i) = *(src + i);
    }
    for (i = countLen; i < n; i++) {
      *(dest + i) = '\0';
    }
  } else {
    for (i = 0; i < n; i++) {
      *(dest + i) = *(src + i);
    }
  }
  return dest;
}
