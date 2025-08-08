#!/bin/bash

# set -eux -o pipefail

# Could this be a Python script instead? How much of the existing build.sh
# scripts do we want to or need to reuse?
#
# Useful features:
#   * sccache/ccache setup
#   * install helpers (on CI runners)
# Tricky features:
#   * install helpers (on developer machines, when tools already exist elsewhere)
#   * Miniconda
#   * VS env override
#   * PYLONG_API_CHECK (???)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

export BUILD_ENVIRONMENT=rocm

export USE_ROCM=ON
export DISTUTILS_USE_SDK=1
# TODO: enable tests
export BUILD_TEST=0
# TODO: enable attention (with aotriton)
export USE_FLASH_ATTENTION=0
export USE_MEM_EFF_ATTENTION=0
# TODO: enable Kineto somehow
export USE_KINETO=0
# TODO: enable GLOO somehow
export USE_GLOO=0

ROCM_ROOT_PATH=$(python -m rocm_sdk path --root)
echo "ROCM_ROOT_PATH: ${ROCM_ROOT_PATH}"
ROCM_BIN_PATH=$(python -m rocm_sdk path --bin)
echo "ROCM_BIN_PATH: ${ROCM_BIN_PATH}"
ROCM_CMAKE_PATH=$(python -m rocm_sdk path --cmake)
echo "ROCM_CMAKE_PATH: ${ROCM_CMAKE_PATH}"

export CMAKE_PREFIX_PATH=${ROCM_CMAKE_PATH}
export ROCM_HOME=${ROCM_ROOT_PATH}
export ROCM_PATH=${ROCM_ROOT_PATH}

# TODO: pull from rocm-sdk or environment
export PYTORCH_ROCM_ARCH=gfx1100


LLVM_DIR_WIN="${ROCM_ROOT_PATH}\\lib\\llvm\\bin"
LLVM_DIR=$(cygpath --unix "${LLVM_DIR_WIN}")
export HIP_CLANG_PATH=${LLVM_DIR}
echo "HIP_CLANG_PATH: ${HIP_CLANG_PATH}"
export CC="${LLVM_DIR_WIN}\\clang-cl.exe"
echo "CC: ${CC}"
export CXX="${LLVM_DIR_WIN}\\clang-cl.exe"
echo "CXX: ${CXX}"
HIP_DEVICE_LIB_PATH_WIN="${ROCM_ROOT_PATH}\\lib\\llvm\\amdgcn\\bitcode"
export HIP_DEVICE_LIB_PATH=${HIP_DEVICE_LIB_PATH_WIN}
echo "HIP_DEVICE_LIB_PATH: ${HIP_DEVICE_LIB_PATH}"

# ${ROOT_DIR}/.ci/pytorch/build.sh
${ROOT_DIR}/.ci/pytorch/win-build.sh
