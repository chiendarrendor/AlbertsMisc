COMMON=../Common/C++
BOOSTINC=/c/Boost/include/boost-1_33_1
INCS=-I${COMMON} -I${BOOSTINC}
GCC=/home/mingw/bin/g++ -g -Wall -Werror ${INCS}

OBJS=thedealer.o poker.o MyRand.o deck.o

poker: ${OBJS}
	${GCC} -o poker ${OBJS}


%.o:%.cpp
	${GCC} -c $<

MyRand.o: ${COMMON}/MyRand.cpp ${COMMON}/MyRand.hpp
	${GCC} -c $<
clean:
	rm *.o