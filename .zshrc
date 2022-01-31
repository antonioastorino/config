if [ -f ~/config/.shell_profile ]; then 
    . ~/config/.shell_profile;
    precmd() { __prompt_command }
fi

