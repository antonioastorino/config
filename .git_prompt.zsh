git_info() {
    local VCS_INFO=''

    __git_dir() {
        local gitroot gitdir
        gitroot="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
        [[ -d "$gitroot/.git" ]] && gitdir="$gitroot/.git" || gitdir=$gitroot

        # Single git call replaces: symbolic-ref, rev-parse --short HEAD,
        # status --porcelain, stash list, rev-parse --verify upstream,
        # rev-list ahead, rev-list behind
        local ref='' commit_id='' remote='' ahead=0 behind=0
        local staged=0 unstaged=0 untracked=0 stash=0

        while IFS= read -r line; do
            case "$line" in
            "# branch.head "*) ref="${line#\# branch.head }" ;;
            "# branch.oid "*)
                commit_id="${line#\# branch.oid }"
                commit_id="${commit_id:0:7}"
                ;;
            "# branch.upstream "*) remote="${line#\# branch.upstream }" ;;
            "# branch.ab "*)
                local ab="${line#\# branch.ab }"
                ahead=${ab%% *}
                ahead=${ahead#+}
                behind=${ab##* }
                behind=${behind#-}
                ;;
            "# stash "*) stash="${line#\# stash }" ;;
            [12]\ [ACDMRT].\ *) ((staged++)) ;;
            [12]\ .[ACDMRT]\ *) ((unstaged++)) ;;
            \?\ *) ((untracked++)) ;;
            esac
        done < <(git status --porcelain=v2 --branch --show-stash 2>/dev/null)

        [[ "$ref" == "(detached)" ]] && {
            DH="Detached HEAD"
            ref=$(git name-rev --name-only --always HEAD)
            ref=${ref#remotes/}
        }
        [[ -z "$commit_id" ]] && commit_id=empty

        VCS_INFO="${DARK_GRAY}(${DARK_GRAY_BOLD}git:${C}${ref}${DARK_GRAY} ${commit_id})"
        VCS_INFO+="${GRAY}("

        local action=''
        if [[ -d "$gitdir/rebase-merge" ]]; then
            [[ -f "$gitdir/rebase-merge/interactive" ]] && action="REBASE-i" || action="REBASE-m"
        elif [[ -d "$gitdir/rebase-apply" ]]; then
            if [[ -f "$gitdir/rebase-apply/rebasing" ]]; then
                action="REBASE"
            elif [[ -f "$gitdir/rebase-apply/applying" ]]; then
                action="AM"
            else action="AM/REBASE"; fi
        elif [[ -f "$gitdir/MERGE_HEAD" ]]; then
            action="MERGING"
        elif [[ -f "$gitdir/BISECT_LOG" ]]; then
            action="BISECTING"
        fi

        [[ -z "$action" ]] && action=$DH
        [[ -n "$action" ]] && VCS_INFO+="${EMR}$action${EMM} "

        [[ ${staged} -ne 0 ]] && staged="${G}${staged}${DARK_GRAY}"
        [[ ${unstaged} -ne 0 ]] && unstaged="${R}${unstaged}${GRAY}"
        [[ ${untracked} -ne 0 ]] && untracked="${Y}${untracked}${GRAY}"
        VCS_INFO+="${staged}/${unstaged}/${untracked}"

        if [[ ${stash} -ne 0 ]]; then
            VCS_INFO+="${GRAY} stash:${Y}${stash}${GRAY})"
        else
            VCS_INFO+="${GRAY})"
        fi

        if [[ -n "$remote" ]]; then
            VCS_INFO+="${GRAY}("
            [[ $ahead != 0 ]] && VCS_INFO+="${G}+$ahead"
            if [[ $behind != 0 ]]; then
                [[ $ahead != 0 ]] && VCS_INFO+="${GRAY}/"
                VCS_INFO+="${R}-$behind"
            fi
            [[ $ahead != 0 || $behind != 0 ]] && VCS_INFO+=" "
            VCS_INFO+="${GRAY}$remote)"
        fi

        VCS_INFO+="${NONE}"
    }

    __git_dir || VCS_INFO=''

    echo $VCS_INFO
}
