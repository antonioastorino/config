if [ -f ~/config/.shell_profile ]; then
    . ~/config/.shell_profile
    precmd() {
        __prompt_command
    }
fi

# === Dynamic Embedded Toolchain Configurations ===

# 1. Dynamically find the ARM GNU Toolchain root and version
DYNAMIC_GCC_ROOT=$(ls -d $HOME/dev/thirdparty/arm-gnu-toolchain-*-arm-none-eabi 2>/dev/null | head -n 1)
if [ -n "$DYNAMIC_GCC_ROOT" ]; then
    export TOOLCHAIN_ROOT="$DYNAMIC_GCC_ROOT"
    export PATH="$TOOLCHAIN_ROOT/bin:$PATH"

    # Extract version details from the binary to format the variable name
    # e.g., "14.2.1" becomes "14_2_1"
    GCC_VER=$("$TOOLCHAIN_ROOT/bin/arm-none-eabi-gcc" -dumpversion 2>/dev/null)
    if [ -n "$GCC_VER" ]; then
        GCC_VAR_SUFFIX=$(echo "$GCC_VER" | tr '.' '_')
        export "GCC_TOOLCHAIN_${GCC_VAR_SUFFIX}"="$TOOLCHAIN_ROOT/bin"
    fi
fi

# 2. Dynamically find the Arm Compiler 6 (AC6) via vcpkg
DYNAMIC_AC6_BIN=$(ls -d $HOME/.vcpkg/artifacts/*/compilers.arm.armclang/*/bin 2>/dev/null | head -n 1)
if [ -n "$DYNAMIC_AC6_BIN" ]; then
    export AC6_ROOT="$(dirname "$DYNAMIC_AC6_BIN")"
    export PATH="$DYNAMIC_AC6_BIN:$PATH"

    AC6_VERSION=$(echo "$DYNAMIC_AC6_BIN" | awk -F'/' '{print $(NF-1)}')
    AC6_VAR_SUFFIX=$(echo "$AC6_VERSION" | tr '.' '_')
    export "AC6_TOOLCHAIN_${AC6_VAR_SUFFIX}"="$DYNAMIC_AC6_BIN"
fi
# =================================================
