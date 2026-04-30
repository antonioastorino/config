if [ -f ~/config/.shell_profile ]; then 
    . ~/config/.shell_profile;
    precmd() { __prompt_command }
fi


if [ "`uname`" = "Linux" ] && ! [ "`uname -m`" = "aarch64" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

