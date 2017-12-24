

#JAVADIR=/c/Program\ Files/Java/jdk1.6.0_03/bin
JAVADIR=/c/Program\ Files/Java/jdk1.5.0_14/bin
TARGET=/c/apache/htdocs/gilthead

all:
	- rm *.class
	${JAVADIR}/javac GiltHeadApplet.java
	${JAVADIR}/jar cf GiltHead.jar *.class *.png *.wav
	cp GiltHead.jar ${TARGET}

