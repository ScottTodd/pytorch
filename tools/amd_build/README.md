# PyTorch AMD Build

AMD scripts like HIPify, for transpiling CUDA into AMD HIP.

TODO: more info here

## Overview

TODO: more info here


## Building PyTorch with ROCm support

TODO: more info here

See also [Installation From Source - AMD ROCm Support](/README.md#amd-rocm-support).

### (Linux) Building with system ROCm

> [!IMPORTANT]
> AMD is moving away from this method of building in favor of the ROCm Python
> packages.

https://rocm.docs.amd.com/projects/install-on-linux/en/latest/

### (Windows) Building with the HIP SDK

> [!IMPORTANT]
> AMD is moving away from this method of building in favor of the ROCm Python
> packages.

https://rocm.docs.amd.com/projects/install-on-windows/en/latest/how-to/install.html

### (Linux and Windows) Building with ROCm Python packages

> [!NOTE]
> This method of building and installing is new and may still have feature gaps.

https://github.com/ROCm/TheRock/blob/main/docs/packaging/python_packaging.md

TODO: move venv and "HIPIFY" steps up a section (generic across OS / packaging style)

1. First create a Python virtual environment and install ROCm Python packages
   into it.

    ```bash
    # TODO: venv setup instructions
    python -m pip install -r requirements.txt
    python -m pip install --index-url https://d2awnip2yjpvqn.cloudfront.net/v2/gfx110X-dgpu/ rocm[libraries,devel]
    ```

2. Prepare source files

    ```bash
    # All commands are from pytorch root.

    # 1. HIPIFY the codebase
    python tools/amd_build/build_amd.py
    # Optionally commit the changes to keep your history clean in following steps
    git checkout -b amd-build
    git add -A
    git commit -m "DO NOT SUBMIT - HIPIFY"

    # 2. Write _rocm_init.py
    python tools/amd_build/write_rocm_it.py
    ```

3. Build (Windows)

    ```bash
    bash ./tools/amd_build/build_windows.sh
    ```

## Scripts

### build_amd.py

[build_amd.py](build_amd.py) is the top-level entry point for HIPifying our
codebase.

Right now, PyTorch and Caffe2 share logic for how to do this transpilation, but
have separate entry-points for transpiling either PyTorch or Caffe2 code.

### build_windows.sh

[build_windows.sh](build_windows.sh) sets environment variables for ROCm on Windows
and then calls [.ci/pytorch/win-build.sh](/.ci/pytorch/win-build.sh) to produce
pytorch wheels.

### write_rocm_init.py

[write_rocm_init.py](write_rocm_init.py) is a utility for writing the
`torch/_rocm_init.py` bootstrap module used by [`torch/__init__.py`](/torch/__init__.py).
