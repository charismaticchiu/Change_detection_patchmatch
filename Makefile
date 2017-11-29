all: normxcorr2_mex

normxcorr2_mex: normxcorr2_mex.cpp
	mex -O cv_src/*.cpp normxcorr2_mex.cpp -output normxcorr2_mex
