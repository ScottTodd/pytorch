#!/bin/bash

# Thin wrapper around .ci/pytorch/win-build.sh for testing on a dev machine.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

export BUILD_ENVIRONMENT=windows-rocm-manywheel
export PYTORCH_ROCM_ARCH=gfx1100

${ROOT_DIR}/.ci/pytorch/win-build.sh
