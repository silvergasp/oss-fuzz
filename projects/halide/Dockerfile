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

FROM gcr.io/oss-fuzz-base/base-builder

RUN apt-get update && apt-get install -y ninja-build lsb-core software-properties-common zlib1g-dev
RUN pip3 install -U cmake

# Build llvm here rather than from build.sh as we aren't going to be updating this on every new commit.
# Note: We can't use the binaries distributed with ubuntu here as we need to compile llvm with the 
# C/XXFLAGS and compilers specified by OSS-fuzz to avoid linker errors.
RUN git clone --depth 1 --branch llvmorg-15.0.0 https://github.com/llvm/llvm-project.git $SRC/llvm-project
RUN cmake -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_ASSERTIONS=ON \
        -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_BUILD_32_BITS=OFF \
        -S $SRC/llvm-project/llvm -B $SRC/llvm-build
RUN cmake --build llvm-build -j$(nproc)
RUN cmake --install llvm-build --prefix $SRC/llvm-install

# TODO: Change this back to main branch
RUN git clone --depth 1 --recurse-submodules -j$(nproc) https://github.com/silvergasp/Halide.git halide
WORKDIR halide
COPY build.sh $SRC/
