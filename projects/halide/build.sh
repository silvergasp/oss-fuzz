#!/bin/bash -eu
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################ 

export LLVM_ROOT=$SRC/llvm-install
export LLVM_CONFIG=$LLVM_ROOT/bin/llvm-config

cmake -G Ninja  -S . -B build -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_DIR=$LLVM_ROOT/lib/cmake/LLVM/LLVMConfig.cmake \
  -DTARGET_WEBASSEMBLY=OFF \
  -DWITH_TUTORIALS=OFF \
  -DWITH_UTILS=OFF \
  -DWITH_PYTHON_BINDINGS=OFF \
  -DWITH_TESTS=ON \
  -DWITH_TEST_AUTO_SCHEDULE=OFF \
  -DWITH_TEST_CORRECTNESS=OFF \
  -DWITH_TEST_ERROR=OFF \
  -DWITH_TEST_WARNING=OFF \
  -DWITH_TEST_PERFORMANCE=OFF \
  -DWITH_TEST_RUNTIME=OFF \
  -DWITH_TEST_GENERATOR=OFF \
  -DWITH_TEST_FUZZ=ON \
  -DBUILD_SHARED_LIBS=OFF

cmake --build ./build -j$(nproc)

find . -name fuzz_simplify
# TODO: Copy over fuzzer to $OUT