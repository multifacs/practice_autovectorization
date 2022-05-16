echo Input test NUMBER
set /p "test="

mkdir result
cd result
mkdir llvm-ir
mkdir benchmarks
cd ..

set "clang=.\llvm\bin\clang.exe"
set "llvm-extract=.\llvm\bin\llvm-extract.exe"
set "llvm-dis=.\llvm\bin\llvm-dis.exe"

set "input=./autovectorization-practise/loops/vectorizable/"
set "src=./autovectorization-practise"
set "benchmark_app=./autovectorization-practise/benchmark_app/benchmark_app.exe"

set "ir=./result/llvm-ir"
set "benchmarks=.\result\benchmarks"

%clang% -O3 -fno-vectorize -fno-unroll-loops -I%input% -DINCLUDE_TEST=\".\test%test%.hpp\" ./autovectorization-practise/test.cpp -emit-llvm -c -o ./autovectorization-practise/test%test%.bc
%llvm-extract% -func=?run@testFunc@@QEAAXXZ %src%/test%test%.bc -o %src%/run-fn.bc
%llvm-dis% %src%/run-fn.bc -o "%ir%/1_no_vectorization_no_unrolling.ll"

".\llvm\bin\clang.exe" -O3 -fno-vectorize -I%input% -DINCLUDE_TEST=\".\test%test%.hpp\" %src%/test.cpp -emit-llvm -c -o %src%/test%test%.bc
%llvm-extract% -func=?run@testFunc@@QEAAXXZ %src%/test%test%.bc -o %src%/run-fn.bc
%llvm-dis% %src%/run-fn.bc -o "%ir%/2_no_vectorization_unrolling.ll"

".\llvm\bin\clang.exe" -O3 -fno-unroll-loops -I%input% -DINCLUDE_TEST=\".\test%test%.hpp\" %src%/test.cpp -emit-llvm -c -o %src%/test%test%.bc
%llvm-extract% -func=?run@testFunc@@QEAAXXZ %src%/test%test%.bc -o %src%/run-fn.bc
%llvm-dis% %src%/run-fn.bc -o "%ir%/3_vectorization_no_unrolling.ll"

".\llvm\bin\clang.exe" -O3 -I%input% -DINCLUDE_TEST=\".\test%test%.hpp\" %src%/test.cpp -emit-llvm -c -o %src%/test%test%.bc
%llvm-extract% -func=?run@testFunc@@QEAAXXZ %src%/test%test%.bc -o %src%/run-fn.bc
%llvm-dis% %src%/run-fn.bc -o "%ir%/4_vectorization_unrolling.ll"

:: Без векторизации и раскрутки
".\llvm\bin\clang.exe" -O3 -fno-vectorize -fno-unroll-loops -Rpass=loop-vectorize %src%/benchmark_app/main.cpp -I %input% -DINCLUDE_TEST=\".\test%test%.hpp\" -o %benchmark_app%
.\autovectorization-practise\benchmark_app\benchmark_app.exe >"%benchmarks%\1_no_vectorization_no_unrolling.txt"

:: Без векторизации, с раскруткой
".\llvm\bin\clang.exe" -O3 -fno-vectorize -Rpass=loop-vectorize %src%/benchmark_app/main.cpp -I %input% -DINCLUDE_TEST=\".\test%test%.hpp\" -o %benchmark_app%
.\autovectorization-practise\benchmark_app\benchmark_app.exe >"%benchmarks%\2_no_vectorization_unrolling.txt"

:: С векторизацией, без раскрутки
".\llvm\bin\clang.exe" -O3 -fno-unroll-loops -Rpass=loop-vectorize %src%/benchmark_app/main.cpp -I %input% -DINCLUDE_TEST=\".\test%test%.hpp\" -o %benchmark_app%
.\autovectorization-practise\benchmark_app\benchmark_app.exe >"%benchmarks%\3_vectorization_no_unrolling.txt"

:: С векторизацией и раскруткой
".\llvm\bin\clang.exe" -O3 -Rpass=loop-vectorize %src%/benchmark_app/main.cpp -I %input% -DINCLUDE_TEST=\".\test%test%.hpp\" -o %benchmark_app%
.\autovectorization-practise\benchmark_app\benchmark_app.exe >"%benchmarks%\4_vectorization_unrolling.txt"