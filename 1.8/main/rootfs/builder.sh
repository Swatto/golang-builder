#!/usr/bin/env bash

# Copyright 2016 The Prometheus Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source /common.sh

# Building binaries for the specified platforms
# The `build` Makefile target is required
declare -a goarchs
goarchs=(${goarchs[@]:-linux\/amd64})
for goarch in "${goarchs[@]}"
do
  goos=${goarch%%/*}
  arch=${goarch##*/}

  echo "# ${goos}-${arch}"
  prefix=".build/${goos}-${arch}"
  mkdir -p "${prefix}"

  if [[ "${goos}" == "windows" ]]; then
    if [[ "${arch}" == "386" ]]; then
      CC="i686-w64-mingw32-gcc" CXX="i686-w64-mingw32-g++" GOOS=${goos} GOARCH=${arch} make PREFIX="${prefix}" build
    else
      CC="x86_64-w64-mingw32-gcc" CXX="x86_64-w64-mingw32-g++" GOOS=${goos} GOARCH=${arch} make PREFIX="${prefix}" build
    fi
  elif [[ "${goos}" == "darwin" ]]; then
    if [[ "${arch}" == "386" ]]; then
      CC="o32-clang" CXX="o32-clang++" GOOS=${goos} GOARCH=${arch} make PREFIX="${prefix}" build
    else
      CC="o64-clang" CXX="o64-clang++" GOOS=${goos} GOARCH=${arch} make PREFIX="${prefix}" build
    fi
  else
    GOOS=${goos} GOARCH=${arch} make PREFIX="${prefix}" build
  fi
done

exit 0
