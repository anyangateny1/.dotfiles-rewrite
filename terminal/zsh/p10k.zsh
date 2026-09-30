# BOILERPLATE / SETUP

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob

    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

    # PROMPT LAYOUT (segment order, separators, multiline connectors)

    # Segments shown on the left. Keep the most important ones here.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        dir # current directory
        vcs # git status
    ) DIR

    # Segments shown on the right, roughly grouped by category (status/perf, language
    # version managers, cloud tooling, shells/file managers, context, misc, time).
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        # -- status / performance --
        status                 # exit code of the last command
        command_execution_time # duration of the last command
        background_jobs        # presence of background jobs
        direnv                 # direnv status (https://direnv.net/)

        # -- language / runtime version managers --
        asdf          # asdf version manager (https://github.com/asdf-vm/asdf)
        virtualenv    # python virtual environment (https://docs.python.org/3/library/venv.html)
        anaconda      # conda environment (https://conda.io/)
        pyenv         # python environment (https://github.com/pyenv/pyenv)
        goenv         # go environment (https://github.com/syndbg/goenv)
        nodenv        # node.js version from nodenv (https://github.com/nodenv/nodenv)
        nvm           # node.js version from nvm (https://github.com/nvm-sh/nvm)
        nodeenv       # node.js environment (https://github.com/ekalinin/nodeenv)
        rbenv         # ruby version from rbenv (https://github.com/rbenv/rbenv)
        rvm           # ruby version from rvm (https://rvm.io)
        fvm           # flutter version management (https://github.com/leoafarias/fvm)
        luaenv        # lua version from luaenv (https://github.com/cehoffman/luaenv)
        jenv          # java version from jenv (https://github.com/jenv/jenv)
        plenv         # perl version from plenv (https://github.com/tokuhirom/plenv)
        perlbrew      # perl version from perlbrew (https://github.com/gugod/App-perlbrew)
        phpenv        # php version from phpenv (https://github.com/phpenv/phpenv)
        scalaenv      # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
        haskell_stack # haskell version from stack (https://haskellstack.org/)

        # -- cloud & infrastructure tooling --
        kubecontext     # current kubernetes context (https://kubernetes.io/)
        terraform       # terraform workspace (https://www.terraform.io)
        aws             # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
        aws_eb_env      # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
        azure           # azure account name (https://docs.microsoft.com/en-us/cli/azure)
        gcloud          # google cloud cli account and project (https://cloud.google.com/)
        google_app_cred # google application credentials (https://cloud.google.com/docs/authentication/production)
        toolbox         # toolbox name (https://github.com/containers/toolbox)

        # -- context & connectivity --
        context # user@hostname
        nordvpn # nordvpn connection status, linux only (https://nordvpn.com/)

        # -- file managers & special shells --
        ranger             # ranger shell (https://github.com/ranger/ranger)
        yazi               # yazi shell (https://github.com/sxyazi/yazi)
        nnn                # nnn shell (https://github.com/jarun/nnn)
        lf                 # lf shell (https://github.com/gokcehan/lf)
        xplr               # xplr shell (https://github.com/sayanarijit/xplr)
        vim_shell          # vim shell indicator (:sh)
        midnight_commander # midnight commander shell (https://midnight-commander.org/)
        nix_shell          # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
        chezmoi_shell      # chezmoi shell (https://www.chezmoi.io/)
        vi_mode            # vi mode (you don't need this if you've enabled prompt_char)

        # -- task / time tracking --
        todo                  # todo items (https://github.com/todotxt/todo.txt-cli)
        timewarrior           # timewarrior tracking status (https://timewarrior.net/)
        taskwarrior           # taskwarrior task count (https://taskwarrior.org/)
        per_directory_history # Oh My Zsh per-directory-history local/global indicator

        # -- clock (always last) --
        time # current time
    )

    # Character set used by powerlevel10k. Best left to `p10k configure`.
    typeset -g POWERLEVEL9K_MODE=unicode
    typeset -g POWERLEVEL9K_ICON_PADDING=none
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

    # Add an empty line before each prompt.
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

    # Multiline connector glyphs (left prefixes / right suffixes for wrapped prompts).
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭-'
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%242F├-'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰-'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%242F-╮'
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%242F-┤'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%242F-╯'

    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
    if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
        typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242
        # Start filler from the edge of the screen if there are no left segments on the first line.
        typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
        # End filler on the edge of the screen if there are no right segments on the first line.
        typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
    fi

    # Segment separators.
    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='|'  # same-color, left
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='|' # same-color, right
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''      # different-color, left
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''     # different-color, right

    # Prompt line endpoints.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

    # PROMPT CHARACTER & OS ICON

    #-------------------------------- os_icon: os identifier ------------------------------------
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
    typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7

    #-------------------------------- prompt_char: prompt symbol --------------------------------
    typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=                                    # transparent background
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76     # green: last command ok
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196 # red: last command failed
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'         # default symbol
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='<'         # vi command mode
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'         # vi visual mode
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='^'         # vi overwrite mode
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=    # no line terminator if last segment
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL= # no line introducer if first segment
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=           # no surrounding whitespace

    # DIRECTORY SEGMENT

    typeset -g POWERLEVEL9K_DIR_BACKGROUND='#6B5B95'
    typeset -g POWERLEVEL9K_DIR_FOREGROUND='#E6E1D4'
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    typeset -g POWERLEVEL9K_SHORTEN_DELIMITER= # symbol replacing removed segment suffixes
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#B5AFA3'
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#E6E1D4'
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

    local anchor_files=(
        .bzr
        .citc
        .git
        .hg
        .node-version
        .python-version
        .go-version
        .ruby-version
        .lua-version
        .java-version
        .perl-version
        .php-version
        .tool-versions
        .mise.toml
        .shorten_folder_marker
        .svn
        .terraform
        CVS
        Cargo.toml
        composer.json
        go.mod
        package.json
        stack.yaml
    )
    typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=last
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2 # don't shorten this many last segments (anchors)
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=50
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
    typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
    typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
    typeset -g POWERLEVEL9K_DIR_CLASSES=()

    # GIT

    typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#76946A'
    typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#DCA561'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#76946A'
    typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND='#C34043'
    typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND='#727169'
    typeset -g POWERLEVEL9K_VCS_FOREGROUND='#E6E1D4'

    # Branch icon. Set to '\UE0A0 ' for the popular Powerline branch icon.
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

    # Custom git status formatter (drives POWERLEVEL9K_VCS_CONTENT_EXPANSION below).
    function my_git_formatter() {
        emulate -L zsh

        if [[ -n $P9K_CONTENT ]]; then
            # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
            # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
            typeset -g my_git_format=$P9K_CONTENT
            return
        fi

        # Styling for different parts of Git status.
        local meta='%7F'       # white foreground
        local clean='%0F'      # black foreground
        local modified='%0F'   # black foreground
        local untracked='%0F'  # black foreground
        local conflicted='%1F' # red foreground

        local res

        if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
            local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
            res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
        fi

        if [[ -n $VCS_STATUS_TAG &&

            -z $VCS_STATUS_LOCAL_BRANCH ]] \
            ; then # Show tag only if not on a branch.
            # <-- this line
            local tag=${(V)VCS_STATUS_TAG}
            # If tag name is at most 32 characters long, show it in full.
            # Otherwise show the first 12 .. the last 12.
            (($#tag > 32)) && tag[13,-13]=".." # <-- this line
            res+="${meta}#${clean}${tag//\%/%%}"
        fi

        # Display the current Git commit if there is no branch and no tag.
        [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] && # <-- this line
            res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

        # Show tracking branch name if it differs from local branch.
        if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
            res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
        fi

        # Display "wip" if the latest commit's summary contains "wip" or "WIP".
        if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
            res+=" ${modified}wip"
        fi

        if ((VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND)); then
            # <42 if behind the remote.
            ((VCS_STATUS_COMMITS_BEHIND)) && res+=" ${clean}<${VCS_STATUS_COMMITS_BEHIND}"
            # >42 if ahead of the remote; no leading space if also behind the remote: <42>42.
            ((VCS_STATUS_COMMITS_AHEAD && ! VCS_STATUS_COMMITS_BEHIND)) && res+=" "
            ((VCS_STATUS_COMMITS_AHEAD)) && res+="${clean}>${VCS_STATUS_COMMITS_AHEAD}"
        elif [[ -n $VCS_STATUS_REMOTE_BRANCH ]]; then

        fi

        # <-42 if behind the push remote.
        ((VCS_STATUS_PUSH_COMMITS_BEHIND)) && res+=" ${clean}<-${VCS_STATUS_PUSH_COMMITS_BEHIND}"
        ((VCS_STATUS_PUSH_COMMITS_AHEAD && ! VCS_STATUS_PUSH_COMMITS_BEHIND)) && res+=" "
        # ->42 if ahead of the push remote; no leading space if also behind: <-42->42.
        ((VCS_STATUS_PUSH_COMMITS_AHEAD)) && res+="${clean}->${VCS_STATUS_PUSH_COMMITS_AHEAD}"
        # *42 if have stashes.
        ((VCS_STATUS_STASHES)) && res+=" ${clean}*${VCS_STATUS_STASHES}"
        # 'merge' if the repo is in an unusual state.
        [[ -n $VCS_STATUS_ACTION ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
        # ~42 if have merge conflicts.
        ((VCS_STATUS_NUM_CONFLICTED)) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
        # +42 if have staged changes.
        ((VCS_STATUS_NUM_STAGED)) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
        # !42 if have unstaged changes.
        ((VCS_STATUS_NUM_UNSTAGED)) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
        # Remove the next line if you don't want to see untracked files at all.
        ((VCS_STATUS_NUM_UNTRACKED)) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
        # "-" if the number of unstaged files is unknown. This can happen due to
        # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
        # than the number of files in the Git index, or due to bash.showDirtyState being set to false
        # in the repository config. The number of staged and untracked files may also be unknown
        # in this case.
        ((VCS_STATUS_HAS_UNSTAGED == -1)) && res+=" ${modified}-"

        typeset -g my_git_format=$res
    }
    functions -M my_git_formatter 2>/dev/null

    typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
    typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'                                    # don't show git status for repos here
    typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true                               # disable default git formatting
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}' # use our formatter
    typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

    # COMMAND STATUS & EXECUTION TIME

    #-------------------------------- status: exit code of the last command ---------------------
    typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

    typeset -g POWERLEVEL9K_STATUS_OK=true
    typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='ok'
    typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
    typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=0

    typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='ok'
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=2
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=0

    typeset -g POWERLEVEL9K_STATUS_ERROR=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='err'
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=3
    typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1

    # Status when the last command was terminated by a signal.
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
    typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false # terse signal names: "INT" not "SIGINT(2)"
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=3
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=1

    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='err'
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=3
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=1

    #-------------------------------- command_execution_time: duration of last command ----------
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=3
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3 # show if takes at least this many seconds
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0 # fractional digits shown (0 = round to seconds)
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

    #-------------------------------- background_jobs: presence of background jobs --------------
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=6
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false # don't show the number of jobs

    #-------------------------------- direnv: direnv status (https://direnv.net/) ---------------
    typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=3
    typeset -g POWERLEVEL9K_DIRENV_BACKGROUND=0

    # LANGUAGE / RUNTIME VERSION MANAGERS

    #-------------------------------- asdf (https://github.com/asdf-vm/asdf) --------------------
    typeset -g POWERLEVEL9K_ASDF_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_BACKGROUND=7
    typeset -g POWERLEVEL9K_ASDF_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=true
    typeset -g POWERLEVEL9K_ASDF_SHOW_ON_UPGLOB=

    # Per-language colors for asdf-managed runtimes.
    typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_RUBY_BACKGROUND=1

    typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_PYTHON_BACKGROUND=4

    typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_GOLANG_BACKGROUND=4

    typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_NODEJS_BACKGROUND=2

    typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_RUST_BACKGROUND=208

    typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_BACKGROUND=5

    typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_FLUTTER_BACKGROUND=4

    typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_LUA_BACKGROUND=4

    typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND=1
    typeset -g POWERLEVEL9K_ASDF_JAVA_BACKGROUND=7

    typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_PERL_BACKGROUND=4

    typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_ERLANG_BACKGROUND=1

    typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_ELIXIR_BACKGROUND=5

    typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_POSTGRES_BACKGROUND=6

    typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_PHP_BACKGROUND=5

    typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_HASKELL_BACKGROUND=3

    typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND=0
    typeset -g POWERLEVEL9K_ASDF_JULIA_BACKGROUND=2

    #-------------------------------- virtualenv / anaconda (Python) ----------------------------
    typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=4
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false # don't show python version next to env name
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
    typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

    typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0
    typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=4
    typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'

    #-------------------------------- pyenv (https://github.com/pyenv/pyenv) --------------------
    typeset -g POWERLEVEL9K_PYENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_PYENV_BACKGROUND=4
    typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global) # hide version if not from these sources
    typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true # false hides version if it's "system"
    typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

    #-------------------------------- goenv (https://github.com/syndbg/goenv) -------------------
    typeset -g POWERLEVEL9K_GOENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_GOENV_BACKGROUND=4
    typeset -g POWERLEVEL9K_GOENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=true

    #-------------------------------- Node.js: nodenv / nvm / nodeenv ---------------------------
    typeset -g POWERLEVEL9K_NODENV_FOREGROUND=2
    typeset -g POWERLEVEL9K_NODENV_BACKGROUND=0
    typeset -g POWERLEVEL9K_NODENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_NVM_FOREGROUND=0
    typeset -g POWERLEVEL9K_NVM_BACKGROUND=5
    typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=2
    typeset -g POWERLEVEL9K_NODEENV_BACKGROUND=0
    typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false
    typeset -g POWERLEVEL9K_NODEENV_{LEFT,RIGHT}_DELIMITER=

    #-------------------------------- node_version / go_version / rust_version / dotnet / php ---
    typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=7
    typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=2
    typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true # only show inside a package.json tree

    typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=255
    typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=2
    typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true

    typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=0
    typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=208
    typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true

    typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND=7
    typeset -g POWERLEVEL9K_DOTNET_VERSION_BACKGROUND=5
    typeset -g POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY=true

    typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=0
    typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND=5
    typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true

    typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND=1
    typeset -g POWERLEVEL9K_LARAVEL_VERSION_BACKGROUND=7

    #-------------------------------- rbenv / rvm (Ruby) -----------------------------------------
    typeset -g POWERLEVEL9K_RBENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_RBENV_BACKGROUND=1
    typeset -g POWERLEVEL9K_RBENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_RVM_FOREGROUND=0
    typeset -g POWERLEVEL9K_RVM_BACKGROUND=240
    typeset -g POWERLEVEL9K_RVM_SHOW_GEMSET=false # don't show @gemset suffix
    typeset -g POWERLEVEL9K_RVM_SHOW_PREFIX=false # don't show "ruby-" prefix

    #-------------------------------- java: java_version / jenv --------------------------------
    typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=1
    typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=7
    typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
    typeset -g POWERLEVEL9K_JAVA_VERSION_FULL=false # brief version string

    typeset -g POWERLEVEL9K_JENV_FOREGROUND=1
    typeset -g POWERLEVEL9K_JENV_BACKGROUND=7
    typeset -g POWERLEVEL9K_JENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=0
    typeset -g POWERLEVEL9K_PACKAGE_BACKGROUND=6

    #-------------------------------- fvm (Flutter) ----------------------------------------------
    typeset -g POWERLEVEL9K_FVM_FOREGROUND=0
    typeset -g POWERLEVEL9K_FVM_BACKGROUND=4

    #-------------------------------- luaenv (Lua) -------------------------------------------------
    typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_LUAENV_BACKGROUND=4
    typeset -g POWERLEVEL9K_LUAENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=true

    #-------------------------------- plenv / perlbrew (Perl) -------------------------------------
    typeset -g POWERLEVEL9K_PLENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_PLENV_BACKGROUND=4
    typeset -g POWERLEVEL9K_PLENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND=67
    typeset -g POWERLEVEL9K_PERLBREW_PROJECT_ONLY=true
    typeset -g POWERLEVEL9K_PERLBREW_SHOW_PREFIX=false # don't show "perl-" prefix

    #-------------------------------- phpenv (PHP) -------------------------------------------------
    typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_PHPENV_BACKGROUND=5
    typeset -g POWERLEVEL9K_PHPENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=true

    #-------------------------------- scalaenv (Scala) ----------------------------------------------
    typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND=0
    typeset -g POWERLEVEL9K_SCALAENV_BACKGROUND=1
    typeset -g POWERLEVEL9K_SCALAENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=true

    #-------------------------------- haskell_stack (Haskell) ----------------------------------------
    typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=0
    typeset -g POWERLEVEL9K_HASKELL_STACK_BACKGROUND=3
    typeset -g POWERLEVEL9K_HASKELL_STACK_SOURCES=(shell local)
    typeset -g POWERLEVEL9K_HASKELL_STACK_ALWAYS_SHOW=true # show even if same as implicit global project

    # CLOUD & INFRASTRUCTURE TOOLING

    #-------------------------------- terraform (https://www.terraform.io) ----------------------
    typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false # don't show workspace if it's "default"
    typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
        '*' OTHER)
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=4
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_BACKGROUND=0

    typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND=4
    typeset -g POWERLEVEL9K_TERRAFORM_VERSION_BACKGROUND=0
    typeset -g POWERLEVEL9K_TERRAFORM_VERSION_SHOW_ON_COMMAND='terraform|tf'

    #-------------------------------- kubecontext (https://kubernetes.io/) ----------------------
    typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold|kubent|kubecolor|cmctl|sparkctl'
    typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
        '*' DEFAULT)
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=5

    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
    POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
    POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

    #-------------------------------- aws / aws_eb_env -------------------------------------------
    typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|cdk|terraform|pulumi|terragrunt'
    typeset -g POWERLEVEL9K_AWS_CLASSES=(
        '*' DEFAULT)
    typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_AWS_DEFAULT_BACKGROUND=1
    typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

    typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=2
    typeset -g POWERLEVEL9K_AWS_EB_ENV_BACKGROUND=0

    #-------------------------------- azure (https://docs.microsoft.com/en-us/cli/azure) --------
    typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|pulumi|terragrunt'
    typeset -g POWERLEVEL9K_AZURE_CLASSES=(
        '*' OTHER)
    typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND=7
    typeset -g POWERLEVEL9K_AZURE_OTHER_BACKGROUND=4

    #-------------------------------- gcloud / google_app_cred (https://cloud.google.com/) ------
    typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
    typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=7
    typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND=4
    typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
    typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'
    typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60

    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_SHOW_ON_COMMAND='terraform|pulumi|terragrunt'
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
        '*' DEFAULT)
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_BACKGROUND=4
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_CONTENT_EXPANSION='${P9K_GOOGLE_APP_CRED_PROJECT_ID//\%/%%}'

    #-------------------------------- toolbox (https://github.com/containers/toolbox) -----------
    typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND=0
    typeset -g POWERLEVEL9K_TOOLBOX_BACKGROUND=3
    typeset -g POWERLEVEL9K_TOOLBOX_CONTENT_EXPANSION='${P9K_TOOLBOX_NAME:#fedora-toolbox-*}' # hide default names

    # FILE MANAGERS & SPECIAL SHELLS

    typeset -g POWERLEVEL9K_RANGER_FOREGROUND=3
    typeset -g POWERLEVEL9K_RANGER_BACKGROUND=0

    typeset -g POWERLEVEL9K_YAZI_FOREGROUND=3
    typeset -g POWERLEVEL9K_YAZI_BACKGROUND=0

    typeset -g POWERLEVEL9K_NNN_FOREGROUND=0
    typeset -g POWERLEVEL9K_NNN_BACKGROUND=6

    typeset -g POWERLEVEL9K_LF_FOREGROUND=0
    typeset -g POWERLEVEL9K_LF_BACKGROUND=6

    typeset -g POWERLEVEL9K_XPLR_FOREGROUND=0
    typeset -g POWERLEVEL9K_XPLR_BACKGROUND=6

    typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=0
    typeset -g POWERLEVEL9K_VIM_SHELL_BACKGROUND=2

    typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=3
    typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_BACKGROUND=0

    typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=0
    typeset -g POWERLEVEL9K_NIX_SHELL_BACKGROUND=4

    typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND=0
    typeset -g POWERLEVEL9K_CHEZMOI_SHELL_BACKGROUND=4

    #-------------------------------- vi_mode --------------------------------------------------
    typeset -g POWERLEVEL9K_VI_MODE_FOREGROUND=0
    typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
    typeset -g POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND=2
    typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
    typeset -g POWERLEVEL9K_VI_MODE_VISUAL_BACKGROUND=4
    typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
    typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_BACKGROUND=3
    typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=
    typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=8

    # SYSTEM RESOURCES (RAM, swap, load, disk, battery, wifi, network, VPN, proxy)

    typeset -g POWERLEVEL9K_RAM_FOREGROUND=1
    typeset -g POWERLEVEL9K_RAM_BACKGROUND=3

    typeset -g POWERLEVEL9K_SWAP_FOREGROUND=0
    typeset -g POWERLEVEL9K_SWAP_BACKGROUND=3

    #-------------------------------- load: CPU load ---------------------------------------------
    typeset -g POWERLEVEL9K_LOAD_WHICH=5             # average over last N minutes: 1, 5, or 15
    typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=0 # < 50%
    typeset -g POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=2
    typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=0 # 50%-70%
    typeset -g POWERLEVEL9K_LOAD_WARNING_BACKGROUND=3
    typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=0 # > 70%
    typeset -g POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=1

    #-------------------------------- disk_usage ----------------------------------------------
    typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=3
    typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND=0
    typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=0
    typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND=3
    typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=7
    typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND=1
    typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
    typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
    typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=false # if true, hide below WARNING_LEVEL

    #-------------------------------- battery -------------------------------------------------
    typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20 # red below this %, not on power
    typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
    typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=2 # green when charging/full
    typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3       # yellow when discharging
    typeset -g POWERLEVEL9K_BATTERY_STAGES=('battery')              # pictograms low -> high
    typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false                   # hide remaining time
    typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=0

    #-------------------------------- wifi / ip / vpn_ip / proxy / cpu_arch --------------------
    typeset -g POWERLEVEL9K_WIFI_FOREGROUND=0
    typeset -g POWERLEVEL9K_WIFI_BACKGROUND=4

    typeset -g POWERLEVEL9K_IP_BACKGROUND=4
    typeset -g POWERLEVEL9K_IP_FOREGROUND=0
    typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_RX_RATE:+<$P9K_IP_RX_RATE }${P9K_IP_TX_RATE:+>$P9K_IP_TX_RATE }$P9K_IP_IP'
    typeset -g POWERLEVEL9K_IP_INTERFACE='[ew].*'

    typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=0
    typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND=6
    typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION= # show just an icon, no IP, when on VPN
    typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*|(zt.*)'
    typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false

    typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=7
    typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=0

    typeset -g POWERLEVEL9K_PROXY_FOREGROUND=4
    typeset -g POWERLEVEL9K_PROXY_BACKGROUND=0

    typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND=0
    typeset -g POWERLEVEL9K_CPU_ARCH_BACKGROUND=3

    #-------------------------------- nordvpn (https://nordvpn.com/, linux only) ---------------
    typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND=7
    typeset -g POWERLEVEL9K_NORDVPN_BACKGROUND=4
    typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_CONTENT_EXPANSION=
    typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_VISUAL_IDENTIFIER_EXPANSION=

    # TASK / TIME TRACKING

    typeset -g POWERLEVEL9K_TODO_FOREGROUND=0
    typeset -g POWERLEVEL9K_TODO_BACKGROUND=8
    typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL=true     # hide when total task count is zero
    typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED=false # hide when filtered task count is zero

    typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=255
    typeset -g POWERLEVEL9K_TIMEWARRIOR_BACKGROUND=8
    typeset -g POWERLEVEL9K_TIMEWARRIOR_CONTENT_EXPANSION='${P9K_CONTENT:0:24}${${P9K_CONTENT:24}:+..}'

    typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND=0
    typeset -g POWERLEVEL9K_TASKWARRIOR_BACKGROUND=6

    typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_FOREGROUND=0
    typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_BACKGROUND=5
    typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_FOREGROUND=0
    typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_BACKGROUND=3

    # CONTEXT (user@hostname)

    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1 # with privileges (root)
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=0
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=3 # in SSH, no privileges
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND=0
    typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=3 # default (no privileges, no SSH)
    typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=0

    typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'

    # Don't show context unless running with privileges or in SSH.
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

    # CLOCK

    typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
    typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}' # see `man 3 strftime`
    typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
    typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

    # CUSTOM SEGMENT

    function prompt_example() {
        p10k segment -b 1 -f 3 -i '*' -t 'hello, %n'
    }

    function instant_prompt_example() {
        # Since prompt_example always makes the same `p10k segment` calls, we can call it from
        # instant_prompt_example. This will give us the same `example` prompt segment in the instant
        # and regular prompts.
        prompt_example
    }

    typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=3
    typeset -g POWERLEVEL9K_EXAMPLE_BACKGROUND=1

    # FINAL BEHAVIOR FLAGS

    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true # hot reload lets you change options after init

    ((! $+functions[p10k])) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

((${#p10k_config_opts})) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
