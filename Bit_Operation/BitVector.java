public class BitVector
{
    /**
     * 32-bit data initialized to all zeros. Here is what you will be using to
     * represent the Bit Vector. Do not change its scope from private.
     */
    private int bits;

    /** You may not add any more fields to this class other than the given one. */

    /**
     * Sets the bit (sets to 1) pointed to by index.
     * @param index index of which bit to set.
     *              0 for the least significant bit (right most bit).
     *              31 for the most significant bit.
     */
    public void set(int index)
    {
        bits = bits | (1 << index);
    }

    /**
     * Clears the bit (sets to 0) pointed to by index.
     * @param index index of which bit to set.
     *              0 for the least significant bit (right most bit).
     *              31 for the most significant bit.
     */
    public void clear(int index)
    {
        bits = bits & ~(1 << index);
    }

    /**
     * Toggles the bit (sets to the opposite of its current value) pointed to by
     * index.
     * @param index index of which bit to set.
     *              0 for the least significant bit (right most bit).
     *              31 for the most significant bit.
     */
    public void toggle(int index)
    {
        bits = bits ^ (1 << index);
    }

    /**
     * Returns true if the bit pointed to by index is currently set.
     * @param index index of which bit to check.
     *              0 for the least significant bit (right-most bit).
     *              31 for the most significant bit.
     * @return true if the bit is set, false if the bit is clear.
     *         If the index is out of range (index >= 32), then return false.
     */
    public boolean isSet(int index)
    {
//        if (index < 32) {
//            return (bit & (1 << index) != 0);
//        }
//        return false;
        return (index < 32) && ((bits & (1 << index)) != 0);
    }

    /**
     * Returns true if the bit pointed to by index is currently clear.
     * @param index index of which bit to check.
     *              0 for the least significant bit (right-most bit).
     *              31 for the most significant bit.
     * @return true if the bit is clear, false if the bit is set.
     *         If the index is out of range (index >= 32), then return true.
     */
    public boolean isClear(int index)
    {
//        if (index < 32) {
//            return (bit & (1 << index) == 0);
//        }
//        return false;
        return (index >= 32) || ((bits & (1 << index)) == 0);
    }

    /**
     * Returns the number of bits currently set (=1) in this bit vector.
     * You may use the ++ operator to increment your counter.
     */
    public int onesCount()
    {
        int count = 0;
        for (int i = 0; i < 32; i++) {
            count = count + (bits & 1);
            bits = bits >> 1;
        }
        return count;
    }

    /**
     * Returns the number of bits currently clear (=0) in this bit vector.
     * You may use the ++ operator to increment your counter.
     */
    public int zerosCount()
    {
        int count = 0;
        for (int i = 0; i < 32; i++) {
            if ((bits & 1) == 0) {
                count++;
            }
            bits = bits >> 1;
        }
        return count;
    }

    /**
     * Returns the "size" of this BitVector. The size of this bit vector is
     * defined to be the minimum number of bits that will represent all of the
     * ones.
     *
     * For example, the size of the bit vector 00010000 will be 5.
     */
    public int size()
    {
        int count = 1;
        int size = 1;
        bits = bits >> 1;
        for (int i = 1; i < 32; i++) {
            count++;
            if ((bits & 1) != 0) {
                size = count;
            }
            bits = bits >> 1;
        }
        return size;
    }
}
