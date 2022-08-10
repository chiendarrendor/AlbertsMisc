public class JavaSide {
    static {
        System.loadLibrary("javaside");
    }


    private long underreference;


    public JavaSide() {
        underreference = getUnderlyingReference();
    }

    public String getThrough() {
        return getUnderlyingString(underreference);
    }


    private native long getUnderlyingReference();
    private native String getUnderlyingString(long underreference);


}
