COMMON=../Common/C++
BOOSTINC=/c/Boost/include/boost-1_46
INCS=-I${COMMON} -I${BOOSTINC}
GCC=g++ -g -Wall -Werror ${INCS}

OBJS=Board.o HexGridPrint.o XYPrint.o BoardCell.o BoardOrganism.o ColorInfo.o

alchemy: ${OBJS} Alchemy.o MyRand.o
	${GCC} -o alchemy.exe Alchemy.o MyRand.o ${OBJS}

boardtest: BoardTest.o  ${OBJS} 
	${GCC} -o boardtest.exe BoardTest.o ${OBJS}

hexgridprinttest: HexGridPrint.o XYPrint.o HexGridPrintTest.o
	${GCC} -o hexgridprinttest.exe $^

xyprinttest: XYPrint.o XYPrintTest.o
	${GCC} -o xyprinttest.exe $^

GATest:
	${GCC} GATest.cpp


%.o:%.cpp
	${GCC} -c $<

Board.o: Board.cpp Board.hpp BoardCell.hpp

Alchemy.o : GA.hpp ${COMMON}/MyRand.hpp

MyRand.o: ${COMMON}/MyRand.cpp ${COMMON}/MyRand.hpp
	${GCC} -c $<
clean:
	rm *.o