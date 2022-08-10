public interface ShortestSubstring {
    // return the (start index,length) of the shortest substring in input that contains
    // every character in charset, or -1 if no such substring exists
    // if a character is duplicated in charset, it must be also duplicated in the substring

    StringPos shortestSubstring(String input,String charset);
}
