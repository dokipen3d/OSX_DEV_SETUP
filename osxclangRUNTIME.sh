INTEL_OPENMP_LATEST_BUILD_LINK=https://www.openmprtl.org/sites/default/files/libomp_20140926_oss.tgz
CLANG_INCLUDE=~/code/llvm/include
CXX_INCLUDE=~/code/llvm/include
CLANG_BIN=~/code/llvm/build/Release/bin
CLANG_LIB=~/code/llvm/build/Release/lib
OPENMP_INCLUDE=~/code/openmp/runtime/build/
OPENMP_LIB=~/code/openmp/runtime/build/


cd ~/
mkdir code
cd ~/code
git clone https://github.com/clang-omp/llvm
git clone https://github.com/clang-omp/compiler-rt llvm/projects/compiler-rt
git clone -b clang-omp https://github.com/clang-omp/clang llvm/tools/clang
git clone https://github.com/llvm-mirror/libcxx llvm/projects/libcxx
git clone https://github.com/llvm-mirror/libcxxabi llvm/projects/libcxxabi
git clone -b extra https://github.com/llvm-mirror/clang-tools-extra llvm/tools/clang/tools/extra
cd llvm
mkdir build
cd build
../configure --enable-optimized --disable-assertions
make -j 4 compiler=clang
cd Release/bin
mv clang clang2
rm -rf clang++
ln -s clang2 clang2++
echo "LLVM+Clang+OpenMP Include Path : " ${CLANG_INCLUDE}
echo "LLVM+Clang+OpenMP Bin Path     : " ${CLANG_BIN}
echo "LLVM+Clang+OpenMP Lib Path     : " ${CLANG_LIB}

cd ~/code
svn co http://llvm.org/svn/llvm-project/openmp/trunk openmp
cd openmp/runtime
mkdir build
cd build
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -Darch=32 .. 
make -j 4
cmake -Darch=32e ..
make -j 4
make fat -j 4


echo "OpenMP Runtime Include Path : " ${OPENMP_INCLUDE}
echo "OpenMP Runtime Lib Path     : " ${OPENMP_LIB}

(echo 'export PATH='${CLANG_BIN}':$PATH';
    echo 'export C_INCLUDE_PATH='${CLANG_INCLUDE}':'${OPENMP_INCLUDE}':$C_INCLUDE_PATH'; 
    echo 'export CPLUS_INCLUDE_PATH='${CLANG_INCLUDE}':'${OPENMP_INCLUDE}':$CPLUS_INCLUDE_PATH';
    echo 'export LIBRARY_PATH='${CLANG_LIB}':'${OPENMP_LIB}':$LIBRARY_PATH';
    echo 'export DYLD_LIBRARY_PATH='${CLANG_LIB}':'${OPENMP_LIB}':$DYLD_LIBRARY_PATH}') >> ~/.profile

echo "LLVM+Clang+OpenMP is now accessible through [ clang2 ] via terminal and does not conflict with Apple's clang"
