public class Bases
{
    /**
     * Convert a string containing ASCII characters (in binary) to an int.
     *
     * You do not need to handle negative numbers. The Strings we will pass in
     * will be valid binary numbers, and able to fit in a 32-bit signed integer.
     *
     * Example: binaryStringToInt("111"); // => 7
     */
    public static int binaryStringToInt(String binary)
    {
        int stringLength = binary.length();
        int result = 0;
        for (int i = 0; i < stringLength; i++) {
            result = (result << 1) + (binary.charAt(i) - 48);
        }
        return result;
    }

    /**
     * Convert a string containing ASCII characters (in decimal) to an int.
     *
     * You do not need to handle negative numbers. The Strings we will pass in
     * will be valid decimal numbers, and able to fit in a 32-bit signed integer.
     *
     * Example: decimalStringToInt("46"); // => 46
     *
     * You may use multiplication in this method.
     */
    public static int decimalStringToInt(String decimal)
    {
        int stringLength = decimal.length();
        int result = 0;
        for (int i = 0; i < stringLength; i++) {
            result = result * 10 + (decimal.charAt(i) - 48);
        }
        return result;
    }

    /**
     * Convert a string containing ASCII characters (in hex) to an int.
     * The input string will only contain numbers and uppercase letters A-F.
     * You do not need to handle negative numbers. The Strings we will pass in will be
     * valid hexadecimal numbers, and able to fit in a 32-bit signed integer.
     *
     * Example: hexStringToInt("A6"); // => 166
     */
    public static int hexStringToInt(String hex)
    {
        int stringLength = hex.length();
        int result = 0;
        for (int i = 0; i < stringLength; i++) {
            if (hex.charAt(i) >= 65) {
                result = (result << 4) + (hex.charAt(i) - 55);
            } else {
                result = (result << 4) + (hex.charAt(i) - 48);
            }
        }
        return result;
    }

    /**
     * Convert a int into a String containing ASCII characters (in octal).
     *
     * You do not need to handle negative numbers.
     * The String returned should contain the minimum number of characters
     * necessary to represent the number that was passed in.
     *
     * Example: intToOctalString(166); // => "246"
     *
     * You may declare one String variable in this method.
     */
    public static String intToOctalString(int octal)
    {
        String result = "";
        int remain = 0;
        while (octal > 0) {
            remain = octal - ((octal >> 3) << 3);
            octal = (octal >> 3);
            result = remain + result;
        }
        return result;
    }

    /**
     * Convert a String containing ASCII characters representing a number in
     * binary into a String containing ASCII characters that represent that same
     * value in hex.
     *
     * The output string should only contain numbers and capital letters.
     * You do not need to handle negative numbers.
     * All binary strings passed in will contain exactly 32 characters.
     * The octal string returned should contain exactly 8 characters.
     *
     * Example: binaryStringToHexString("00001111001100101010011001011100"); // => "0F32A65C"
     *
     * You may declare one String variable in this method.
     */
    public static String binaryStringToHexString(String binary)
    {
        String result = "";
        int num = 0;
        char numToChar;
        for (int i = 0; i < 8; i++) {
            num = ((binary.charAt(0 + (i << 2)) - 48) << 3) + ((binary.charAt(1 + (i << 2)) - 48) << 2)
                    + ((binary.charAt(2 + (i << 2)) - 48) << 1) + (binary.charAt(3 + (i << 2)) - 48);
            if (num >= 10) {
                numToChar = (char)(num - 10 + 'A');
            } else {
                numToChar = (char)(num + '0');
            }
            result = result + numToChar;
        }
        return result;
    }
}
