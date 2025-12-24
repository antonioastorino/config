git_info(){
    local VCS_INFO=''

    __git_dir() {
        local gitroot gitdir
        gitroot="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
        [[ -d "$gitroot/.git" ]] && gitdir="$gitroot/.git" || gitdir=$gitroot

        local ref=$(git symbolic-ref -q HEAD)
        if [[ -n "$ref" ]]; then
            ref=${ref#refs/heads/}
            ref=${ref#refs/tags/}
        else
            # Detached head
            DH="Detached HEAD"
            ref=$(git name-rev --name-only --always HEAD)
            ref=${ref#remotes/}
        fi

        local commit_id=$(git rev-parse --quiet --short HEAD)
        if [[ -z "$commit_id" ]]; then
            commit_id=empty
        fi

        VCS_INFO="${DARK_GRAY}(${DARK_GRAY_BOLD}git:${C}${ref}${DARK_GRAY} ${commit_id})"

        VCS_INFO+="${GRAY}("
        # multistep actions e.g.: rebase -i/merge conflict/etc...
        # Logic inspired by https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
        local action=''
        if [[ -d "$gitdir/rebase-merge" ]]; then
            if [[ -f "$gitdir/rebase-merge/interactive" ]]; then
                action="REBASE-i"
            else
                action="REBASE-m"
            fi
        else
            if [[ -d "$gitdir/rebase-apply" ]]; then
                if [[ -f "$gitdir/rebase-apply/rebasing" ]]; then
                    action="REBASE"
                elif [[ -f "$gitdir/rebase-apply/applying" ]]; then
                    action="AM"
                else
                    action="AM/REBASE"
                fi
            elif [[ -f "$gitdir/MERGE_HEAD" ]]; then
                action="MERGING"
            elif [[ -f "$gitdir/BISECT_LOG" ]]; then
                action="BISECTING"
            fi
        fi

        # Warn about Detached HEAD if there is no other action running
        [[ -z "$action" ]] && action=$DH
        [[ -n "$action" ]] && VCS_INFO+="${EMR}$action${EMM} "

        # staged / unstaged / untracked changes
        local staged=0; unstaged=0; untracked=0
        while IFS= read line
        do
            [[ "$line" = [ACDMRT]?\ * ]] && ((staged++));
            [[ "$line" = ?[ACDMRT]\ * ]] && ((unstaged++));
            [[ "$line" = \?\?\ *      ]] && ((untracked++));
        done < <(git status --porcelain 2>/dev/null)
        
        [[ ${staged}    -ne 0 ]] && staged="${G}${staged}${DARK_GRAY}"
        [[ ${unstaged}  -ne 0 ]] && unstaged="${R}${unstaged}${GRAY}"
        [[ ${untracked} -ne 0 ]] && untracked="${Y}${untracked}${GRAY}"
        VCS_INFO+="${staged}/${unstaged}/${untracked}"

        # stash
        if [[ -s ${gitdir}/refs/stash ]]; then
            local stash=$(git stash list 2>/dev/null | wc -l)
            VCS_INFO+="${GRAY} stash:${Y}${stash}${GRAY})"
        else
            VCS_INFO+="${GRAY})"
        fi

        # Are we on a remote-tracking branch?
        local remote
        remote=$(git rev-parse --verify ${branch}@{upstream} --symbolic-full-name 2>/dev/null)
        remote=${remote#refs/remotes/}

        if [[ -n "$remote" ]]
        then
            VCS_INFO+="${GRAY}("

            # for git prior to 1.7
            # ahead=$(git rev-list origin/${branch}..HEAD | wc -l)
            local ahead=$(git rev-list ${branch}@{upstream}..HEAD 2>/dev/null | wc -l | awk '{print $1}')
            if [[ $ahead != 0 ]]
            then
                VCS_INFO+="${G}+$ahead"
            fi

            # for git prior to 1.7
            # behind=$(git rev-list HEAD..origin/${branch} | wc -l)
            local behind=$(git rev-list HEAD..${branch}@{upstream} 2>/dev/null | wc -l | awk '{print $1}')
            if [[ $behind != 0 ]]
            then
                [[ $ahead != 0 ]] && VCS_INFO+="${GRAY}/"
                VCS_INFO+="${R}-$behind"
            fi

            if [[ $ahead != 0 ]] || [[ $behind != 0 ]]
            then
                VCS_INFO+=" "
            fi

            VCS_INFO+="${GRAY}$remote)"
        fi

        VCS_INFO+="${NONE}"
    }

    __git_dir || VCS_INFO=''

    echo $VCS_INFO
}
