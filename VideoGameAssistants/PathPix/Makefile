
BOOSTINC=/c/Boost/include/boost-1_33_1

SOLVERCPP=Board.cpp Path.cpp PathPix.cpp
IMAGECPP=ImageReader.cpp bitmap_Image.cpp CellScanner.cpp

solver:
	g++ -g -Wall -Werror -o pathpix -I${BOOSTINC} ${SOLVERCPP}
imagereader: ${IMAGECPP}
	g++ -g -Wall -Werror -o imagereader -I${BOOSTINC} ${IMAGECPP}
bitest:
	g++ -g -Wall -Werror -o bitest bitmap_Image.cpp main.cpp
