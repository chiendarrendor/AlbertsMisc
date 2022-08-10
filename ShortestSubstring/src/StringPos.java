class StringPos {
    int length = Integer.MAX_VALUE;
    int position = -1;

    public void update(int newpos,int newlen) {
        if (newlen < length) {
            length = newlen;
            position = newpos;
        }
    }
}
