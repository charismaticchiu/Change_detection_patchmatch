# Optimized (slow to build)
mex CXXOPTIMFLAGS='-g -O6 -w -s -ffast-math -fomit-frame-pointer -fstrength-reduce -fopenmp -msse2 -funroll-loops -fPIC' CXXFLAGS='-DNDEBUG -DUNIX_MODE -DMEXMODE -fopenmp' CXXLIBS='${CXXLIBS} -Wl,--export-dynamic -Wl,-e,mexFunction -shared -lgomp' knn.cpp mexutil.cpp nn.cpp nnmex.cpp patch.cpp vecnn.cpp simnn.cpp allegro_emu.cpp -output nnmex -output nnmex
mex CXXOPTIMFLAGS='-g -O6 -w -s -ffast-math -fomit-frame-pointer -fstrength-reduce -fopenmp -msse2 -funroll-loops -fPIC' CXXFLAGS='-DNDEBUG -DUNIX_MODE -DMEXMODE -fopenmp' CXXLIBS='${CXXLIBS} -Wl,--export-dynamic -Wl,-e,mexFunction -shared -lgomp' knn.cpp mexutil.cpp nn.cpp votemex.cpp patch.cpp vecnn.cpp simnn.cpp allegro_emu.cpp -output nnmex -output votemex
# '-g' is used for enabling GDB debugger
# Unoptimized (fast to build)
#mex CXXOPTIMFLAGS='-w -fPIC' CXXFLAGS='-DNDEBUG -DUNIX_MODE -DMEXMODE -fopenmp' CXXLIBS='${CXXLIBS} -Wl,--export-dynamic -Wl,-e,mexFunction -shared -lgomp' -inline knn.cpp mexutil.cpp nn.cpp nnmex.cpp patch.cpp vecnn.cpp simnn.cpp allegro_emu.cpp -output nnmex -output nnmex
#mex CXXOPTIMFLAGS='-w -fPIC' CXXFLAGS='-DNDEBUG -DUNIX_MODE -DMEXMODE -fopenmp' CXXLIBS='${CXXLIBS} -Wl,--export-dynamic -Wl,-e,mexFunction -shared -lgomp' -inline knn.cpp mexutil.cpp nn.cpp votemex.cpp patch.cpp vecnn.cpp simnn.cpp allegro_emu.cpp -output nnmex -output votemex
