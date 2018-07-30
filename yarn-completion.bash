# shellcheck shell=bash disable=2207
#
# Version: 0.8.0
# Yarn Version: 1.9.2
#
# bash completion for Yarn (https://github.com/yarnpkg/yarn)
#
# To enable the completions either:
#  - place this file in /etc/bash_completion.d
#  or
#  - copy this file to e.g. ~/.yarn-completion.sh and add the line
#    below to your .bashrc after bash completion features are loaded
#    . ~/.yarn-completion.sh
#

# Returns the object keys for a given first-level property
# in a package.json file located in the current directory if it exists.
#
# Optional flags:
#   -g  query     the package.json of the globals
#   -t  FIELDTYPE the field type of interest (array, boolean, number, object, string)
#
# @param $1 field_key  The first-level property of interest.
#
__yarn_get_package_fields() {
    declare field_key
    declare field_type='object'
    declare package_dot_json
    declare cwd
    cwd="$(pwd)"

    while [[ $cwd != '/' ]]; do
        if [[ -f "$cwd/package.json" ]]; then
            package_dot_json="$cwd/package.json"
            break
        fi
        cwd="$(dirname "$cwd")"
    done

    declare OPTIND OPTARG opt
    while getopts ":gt:" opt; do
        case $opt in
            g)
                if [[ -f $HOME/.config/yarn/global/package.json ]]; then
                    package_dot_json="$HOME/.config/yarn/global/package.json"
                elif [[ -f $HOME/.local/share/yarn/global/package.json ]]; then
                    package_dot_json="$HOME/.local/share/yarn/global/package.json"
                elif [[ -f $HOME/.yarn/global/package.json ]]; then
                    package_dot_json="$HOME/.yarn/global/package.json"
                else
                    package_dot_json=""
                fi
                ;;
            t)
                case "$OPTARG" in
                    array | boolean | number | object | string)
                        field_type="$OPTARG"
                        ;;
                esac
                ;;
            *) ;;

        esac
    done
    shift $((OPTIND - 1))

    field_key="\"$1\""

    [[ ! -f $package_dot_json || ! $field_key ]] && return

    case "$field_type" in
        object)
            sed -n '/'"$field_key"':[[:space:]]*{/,/^[[:space:]]*}/{
                # exclude start and end patterns
                //!{
                    # extract the text between the first pair of double quotes
                    s/^[[:space:]]*"\([^"]*\).*/\1/p
                }
            }' "$package_dot_json"
            ;;
        array)
            sed -n '/'"$field_key"':[[:space:]]*\[/,/^[[:space:]]*]/{
                # exclude start and end patterns
                //!{
                    # extract the text between the first pair of double quotes
                    s/^[[:space:]]*"\([^"]*\).*/\1/p
                }
            }' "$package_dot_json"
            ;;
        boolean | number)
            sed -n 's/[[:space:]]*'"$field_key"':[[:space:]]*\([a-z0-9]*\)/\1/p' "$package_dot_json"
            ;;
        string)
            sed -n 's/[[:space:]]*'"$field_key"':[[:space:]]*"\(.*\)".*/\1/p' "$package_dot_json"
            ;;
    esac
}

# bash-completion _filedir backwards compatibility
__yarn_filedir() {
    if [[ "$cur" == @* && -d ./node_modules ]]; then
        COMPREPLY=($(compgen -f -- "./node_modules/$cur" | sed 's/^[^@]*\(@.*\)/\1/'))
    else
        COMPREPLY=($(compgen -f -- "$cur"))
    fi
    compopt -o nospace
}

# `_count_args` backwards compatibility.
#
# The following variables must be declared prior to invocation:
#   counter INT the start index to begin looking for commands
#   args INT    the argument counter
__yarn_count_args() {
    args=0
    counter=1
    while [[ $counter -lt $cword ]]; do
        [[ ${words[$counter]} != -* ]] && ((args++))
        ((counter++))
    done
}

# Prints the nth word of the completion line, excluding flags
# @param $1 idx  The 1-based index of the word of interest
__yarn_nth_word() {
    declare -i idx="$1"
    declare -i counter=0
    declare -i cword=0
    while [ "$counter" -lt "$idx" ]; do
        case "${words[$counter]}" in
            [^-]*)
                ((cword++))
                if [ "$cword" -eq "$idx" ]; then
                    echo "${words[$counter]}"
                    return
                fi
                ;;
        esac
        ((counter++))
    done
}

# Retrieves the current command word, which is the first occurring word after
# `counter` that isn't a flag.
#
# The following variables must be declared prior to invocation:
#   counter INT the start index to begin looking for commands
#   cmd         the command word
__yarn_get_command() {
    cmd=yarn
    while [[ $counter -lt $COMP_CWORD ]]; do
        case "${words[$counter]}" in
            -*) ;;

            =)
                ((counter++))
                ;;
            *)
                cmd="${words[$counter]}"
                break
                ;;
        esac
        ((counter++))
    done
}

_yarn_add() {
    declare flags=(
        --dev
        --exact
        --optional
        --peer
        --tilde
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_autoclean() {
    declare flags=(
        --force -F
        --init -I
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_cache() {
    declare subcommands=(
        clean
        dir
        list
    )
    case "$prev" in
        cache)
            COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
            ;;
        list)
            case "$cur" in
                -*)
                    COMPREPLY=($(compgen -W "--pattern" -- "$cur"))
                    ;;
            esac
            ;;
    esac
}

_yarn_check() {
    [[ "$prev" != check ]] && returny
    declare flags=(
        --integrity
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_config() {
    declare subcommands=(
        delete
        get
        list
        set
    )
    declare known_keys=(
        ignore-optional
        ignore-platform
        ignore-scripts
        init-author-email
        init-author-name
        init-author-url
        init-license
        init-version
        no-progress
        prefix
        registry
        save-prefix
        user-agent
        version-git-message
        version-git-sign
        version-git-tag
        version-tag-prefix
    )

    case "$prev" in
        get | delete)
            COMPREPLY=($(compgen -W "${known_keys[*]}" -- "$cur"))
            ;;
        set)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=($(compgen -W "--global" -- "$cur"))
            else
                COMPREPLY=($(compgen -W "${known_keys[*]}" -- "$cur"))
            fi
            ;;
        config)
            COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_create() {
    declare -i args counter
    __yarn_count_args
    if [[ $args -eq 2 ]]; then
        __yarn_filedir
    fi
}

_yarn_global() {
    declare subcmd="${words[$((counter + 1))]}"
    declare subcommands=(
        add
        bin
        list
        remove
        upgrade
        upgrade-interactive
    )
    case "$subcmd" in
        add | bin | remove | upgrade | upgrade-interactive)
            declare global_completions_func=_yarn_${subcmd//-/_}
            declare -F "$global_completions_func" > /dev/null && $global_completions_func global
            ;;
        list | --depth)
            _yarn_list
            ;;
        *)
            COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_help() {
    [[ "$prev" != help ]] && return
    COMPREPLY=($(compgen -W "${commands[*]}" -- "$cur"))
}

_yarn_info() {
    declare flags=(
        --json
    )
    declare standard_fields=(
        author
        bin
        bugs
        contributors
        dependencies
        description
        devDependencies
        dist-tags
        engines
        files
        homepage
        keywords
        license
        main
        maintainers
        name
        optionalDependencies
        peerDependencies
        repository
        version
        versions
    )

    [[ "$prev" == info ]] && return

    declare -i args counter
    __yarn_count_args

    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
        *)
            if [[ $args -eq 2 ]]; then
                COMPREPLY=($(compgen -W "${standard_fields[*]}" -- "$cur"))
            fi
            ;;
    esac
}

_yarn_init() {
    declare flags=(
        --yes -y
        --private -p
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_install() {
    declare flags=(
        --flat
        --force
        --har
        --modules-folder
        --no-lockfile
        --production
        --pure-lockfile
    )

    case "$prev" in
        --modules-folder)
            compopt -o dirnames
            return
            ;;
    esac

    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_licenses() {
    [[ "$prev" != licenses ]] && return
    declare subcommands=(
        list
        generate-disclaimer
    )
    COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
}

_yarn_list() {
    declare flags=(
        --depth
        --pattern
    )

    case "$prev" in
        list) ;;

        --depth)
            COMPREPLY=($(compgen -W '{0..9}' -- "$cur"))
            return
            ;;
        *)
            return
            ;;
    esac

    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_outdated() {
    [[ "$prev" != outdated ]] && return
    declare dependencies
    declare devDependencies
    dependencies=$(__yarn_get_package_fields dependencies)
    devDependencies=$(__yarn_get_package_fields devDependencies)
    COMPREPLY=($(compgen -W "$dependencies $devDependencies" -- "$cur"))
}

_yarn_owner() {
    [[ "$prev" != owner ]] && return
    declare subcommands=(
        add
        list
        remove
    )
    COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
}

_yarn_pack() {
    declare flags=(
        --filename
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            return
            ;;
    esac
    case "$prev" in
        --filename)
            compopt -o dirnames
            ;;
    esac
}

_yarn_publish() {
    declare flags=(
        --access
        --new-version
        --non-interactive
        --tag
    )
    case "$prev" in
        --access)
            COMPREPLY=($(compgen -W "public restricted" -- "$cur"))
            return
            ;;
        --tag | --new-version)
            return
            ;;
    esac
    compopt -o dirnames
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            return
            ;;
    esac
}

_yarn_remove() {
    declare location="$1"
    declare dependencies
    declare devDependencies
    case "$cur" in
        -*)
            # remove shares the same flags as install
            _yarn_install
            ;;
        *)
            if [[ "$location" == 'global' ]]; then
                dependencies=$(__yarn_get_package_fields -g dependencies)
                devDependencies=''
            else
                dependencies=$(__yarn_get_package_fields dependencies)
                devDependencies=$(__yarn_get_package_fields devDependencies)
            fi
            COMPREPLY=($(compgen -W "$dependencies $devDependencies" -- "$cur"))
            ;;
    esac
}

_yarn_run() {
    declare subcommands=(
        env
        $(__yarn_get_package_fields scripts)
    )
    case "$prev" in
        run)
            COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
            ;;
        *)
            compopt -o dirnames
            ;;
    esac
}

_yarn_tag() {
    [[ "$prev" != tag ]] && return
    declare subcommands=(
        add
        list
        remove
    )
    COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
}

_yarn_team() {
    [[ "$prev" != team ]] && return
    declare subcommands=(
        add
        create
        destroy
        list
        remove
    )
    COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
}

_yarn_upgrade() {
    declare location="$1"
    declare dependencies
    declare devDependencies
    declare flags=(
        --caret
        --exact
        --ignore-engines
        --latest -L
        --pattern
        --scope -S
        --tilde
    )
    case "$prev" in
        --pattern | --scope)
            return
            ;;
    esac
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
        *)
            if [[ "$location" == global ]]; then
                dependencies=$(__yarn_get_package_fields -g dependencies)
                devDependencies=''
            else
                dependencies=$(__yarn_get_package_fields dependencies)
                devDependencies=$(__yarn_get_package_fields devDependencies)
            fi
            COMPREPLY=($(compgen -W "$dependencies $devDependencies" -- "$cur"))
            ;;
    esac
}

_yarn_upgrade_interactive() {
    declare flags=(
        --latest
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
        *)
            return
            ;;
    esac
}

_yarn_version() {
    declare flags=(
        --major
        --minor
        --new-version
        --no-commit-hooks
        --no-git-tag-version
        --patch
    )
    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${flags[*]}" -- "$cur"))
            ;;
    esac
}

_yarn_workspace() {
    if [[ $prev == workspace ]]; then
        # Prevents infinite recursion of workspace completion
        [[ $COMP_CWORD == 2 ]] || return
        declare -a workspaces
        declare module_path
        for module_path in $(__yarn_get_package_fields -t array workspaces); do
            workspaces+=("$(basename "$module_path")")
        done
        COMPREPLY=($(compgen -W "${workspaces[*]}" -- "$cur"))
        return
    fi

    declare cmd
    declare -i counter=3
    __yarn_get_command

    declare completions_func=_yarn_${cmd//-/_}
    declare -F "$completions_func" > /dev/null && $completions_func
}

_yarn_workspaces() {
    [[ "$prev" != workspaces ]] && return
    declare subcommands=(
        info
    )
    COMPREPLY=($(compgen -W "${subcommands[*]}" -- "$cur"))
}

_yarn_why() {
    declare modules_folder
    declare modules

    modules_folder="$(pwd)/node_modules"
    [ ! -d "$modules_folder" ] || [[ "$prev" != why ]] && return

    if [[ "$cur" == ./* || "$cur" == @*/ ]]; then
        __yarn_filedir
    else
        modules=$(
            find node_modules -maxdepth 1 -mindepth 1 -type d -not -name .bin \
                | sort \
                | sed -e 's|node_modules/||' # Remove 'node_modules/' prefix
        )
        if [[ "$cur" == @* ]]; then
            modules=$(sed -e 's|$|/|' <<< "$modules") # append a trailing backslash
            compopt -o nospace
        fi
        COMPREPLY=($(compgen -W "$modules" -- "$cur"))
    fi
}

_yarn_yarn() {
    declare -i args counter
    __yarn_count_args

    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "${global_flags[*]}" -- "$cur"))
            ;;
        *)
            if [[ $args == 0 || "$(__yarn_nth_word 2)" == 'workspace' ]]; then
                compopt -o plusdirs # fallback to directory name completion if no matches
                COMPREPLY=($(compgen -W "${commands[*]}" -- "$cur"))
            fi
            ;;
    esac
}

_yarn() {
    # Fixes https://github.com/dsifford/yarn-completion/issues/9
    declare prev_comp_wordbreaks=$COMP_WORDBREAKS
    COMP_WORDBREAKS="\"'><=;|&(: "

    declare cur prev words cword
    declare commands=(
        access
        add
        autoclean
        bin
        cache
        check
        config
        create
        exec
        generate-lock-entry
        global
        help
        import
        info
        init
        install
        licenses
        link
        list
        login
        logout
        node
        outdated
        owner
        pack
        publish
        remove
        run
        tag
        team
        unlink
        upgrade
        upgrade-interactive
        version
        versions
        workspace
        workspaces
        why
        $(__yarn_get_package_fields scripts)
    )

    declare global_flags=(
        --cache-folder
        --check-files
        --cwd
        --emoji
        --flat
        --force
        --frozen-lockfile
        --global-folder
        --har
        --help
        --https-proxy
        --ignore-engines
        --ignore-optional
        --ignore-platform
        --ignore-scripts
        --json
        --link-duplicates
        --link-folder
        --modules-folder
        --mutex
        --network-concurrency
        --network-timeout
        --no-bin-links
        --no-default-rc
        --no-emoji
        --no-lockfile
        --no-progress
        --non-interactive
        --offline
        --prefer-offline
        --preferred-cache-folder
        --prod
        --production
        --proxy
        --pure-lockfile
        --scripts-prepend-node-path
        --silent
        --skip-integrity-check
        --strict-semver
        --use-rc
        --verbose
        --version
    )

    COMPREPLY=()
    if command -v _init_completion > /dev/null; then
        _init_completion
    else
        if command -v _get_comp_words_by_ref > /dev/null; then
            _get_comp_words_by_ref cur prev words cword
        fi
    fi

    declare cmd
    declare -i counter=1
    __yarn_get_command

    declare completions_func="_yarn_${cmd//-/_}"
    declare -F "$completions_func" > /dev/null && $completions_func

    # default back to path matching if no completions_func defined
    if declare -F "$completions_func" > /dev/null; then
        $completions_func
    else
        __yarn_filedir
    fi

    # Resets back to users' settings
    COMP_WORDBREAKS="$prev_comp_wordbreaks"
    return 0
}

complete -F _yarn yarn
