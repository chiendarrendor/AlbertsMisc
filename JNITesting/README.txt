System configuration:
* Intel 54 bit processor, Windows 10
* Intellj installed
* MinGW installed
* TDM-GCC (64-bit C++ compiler, could be done by installing the 64-bit MinGW) installed
* Java jdk installed C:/Program Files/Java/jdk1.8.0_151

setup:
in Intellij:  Settings->Tools->External Tools
'+' to create new External Tool:
    Name: javah
    Group: Java
    Description: JAva Native Interface C Header and Stub File Generator
    Program: $JDKPath$\bin\javah.exe
    Arguments: -jni -v -d $FileDir$ $FileClass$
    Working directory: $SourcepathEntry$
    Show in: Main Menu, Editor Menu, Project views, Search result
    Advanced Options:
        Synchronize files after execution,
        Open console for tool output,
        Make console active on message in stdout,
        Make console active on message in stderr

to test classes in pure C++:
(in MinGW shell)
cd cppcode
/d/TDM-GCC/bin/g++ HolderClass.cpp Main.cpp MasterClass.cpp -o classtest
cd ..
cppcode/classtest

to compile DLL for JNI:
in IntelliJ:
    open the JavaSide.java file
    Tools->Java->javah
in MinGW shell:
    /d/TDM-GCC/bin/g++ -I../src -I'/c/Program Files/Java/jdk1.8.0_151/include' -I'/c/Program Files/Java/jdk1.8.0_151/include/win32' *.cpp -shared -o javaside.dll -m64
in IntelliJ:
    edit Execution Configuration VM Options to add: -Djava.library.path=cppcode
    build and execute the Java code!

TBD:
    there should be a way to add more build directives to the project, so that the javah and the g++ can be done within the Intellij 'build'



