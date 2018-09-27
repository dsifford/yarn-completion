#!/usr/bin/env bash

for src in \
	"$TEST_DIR"/../yarn-completion.bash \
	/usr/share/bash-completion/bash_completion \
	/usr/local/share/bash-completion/bash_completion; do
	# shellcheck disable=SC1090
	[ -f "$src" ] && source "$src"
done
unset src

##
# Retrieve a list of bash completions for a given COMMAND.
#
# Usage:
#   get_completions COMMAND...
##
get_completions() {
	declare COMP_LINE=$*
	declare -i COMP_POINT=${#COMP_LINE}
	declare -a COMP_WORDS=("$@")
	declare -i COMP_CWORD=$((${#COMP_WORDS[@]} - 1))
	declare -a COMPREPLY=()

	_yarn 2> /dev/null

	if [[ "${#COMPREPLY[@]}" -gt 0 ]]; then
		printf '%s\n' "${COMPREPLY[@]}" | LC_ALL=C sort -u
	fi
}

##
# Retrieve a sorted list of commands or subcommands.
#
# Usage:
#     get_commands [COMMAND...]
#
##
get_commands() {
	if [[ $# -gt 0 ]]; then
		yarn help "$@" | sed -n '
			s/^.*Usage:.*\[\([a-z|-]*\)\].*\[flags\]/\1/p
		' | tr '|' '\n'
	else
		yarn help | sed -n '
			/Commands:/,/^[[:blank:]]*[^-]$/{
				s/[[:blank:]]*- \([a-z-]*\).*/\1/p
			}
		' | LC_ALL=C sort -u
	fi
}

##
# Retrieve a sorted list of options for a given COMMAND.
#
# Usage:
#     get_options [-g] COMMAND
#     get_options -g
#
# Options:
#     -g, --global  Retrieve global options.
##
get_options() {
	declare OPTS
	declare -i global=0
	declare global_options=''
	declare local_options=''

	if ! OPTS=$(getopt -o 'g' -l 'global' -n 'get_options' -- "$@"); then
		exit 1
	fi
	eval set -- "$OPTS"

	while true; do
		case "$1" in
			-g | --global)
				global=1
				shift
				;;
			--)
				shift
				break
				;;
			*)
				exit 1
				;;
		esac
	done

	global_options=$(
		yarn help | sed -n \
			-e '/Options:/,/Commands:/{
				s/DEPRECATED//
				t end
				s/^[[:blank:]]*\(-[[:alpha:]]\), \(--[a-z-]*\).*/\1\n\2/p
				s/^[[:blank:]]*\(--[a-z-]*\), \(--[a-z-]*\).*/\1\n\2/p
				s/^[[:blank:]]*\(--[a-z-]*\).*/\1/p
				:end
			}' | LC_ALL=C sort -u
	)

	if [[ ! -z $1 ]]; then
		local_options=$(
			LC_ALL=C comm -23 \
				<(
					yarn help "$1" | sed -n '/Options:/,/Commands:/{
						s/DEPRECATED//
						t end
						s/^[[:blank:]]*\(-[[:alpha:]]\), \(--[a-z-]*\).*/\1\n\2/p
						s/^[[:blank:]]*\(--[a-z-]*\), \(--[a-z-]*\).*/\1\n\2/p
						s/^[[:blank:]]*\(--[a-z-]*\).*/\1/p
						:end
					}' | LC_ALL=C sort -u
				) \
				<(echo "$global_options")
		)
	fi

	[ ! -z "$local_options" ] && echo "$local_options"
	((global)) && echo "$global_options"
}

###
# HELPERS
##

describe() {
	echo_fill --fill = '' 
	echo "$@"
	echo_fill --fill = ''
}

it() {
	echo_fill -n --columns 64 "  $*" 
}

passfail() {
	# shellcheck disable=SC2181
	if [[ $? -gt 0 ]]; then
		echo FAILED
		echo "$@"
		((FAILURES++))
	else
		echo ....OK
	fi
}

prepend() {
	declare str="$1"
	cat | sed "s/^/$str/"
}

##
# Print a line of text with a trailing fill.
#
# Usage:
#     echo_fill [-n] [-f CHAR -l NUMBER] <text>...
#
# -n                           Do not print trailing newline
# -c NUMBER, --columns=NUMBER  Length of line [default: 70]
# -f CHAR, --fill=CHAR         Character used to fill remaining columns [default: .]
#
##
echo_fill() {
	declare OPTS=
	declare input=
	declare fill='.'
	declare -i columns=70
	declare -i newline=1

	if ! OPTS=$(getopt -o 'f:c:n' -l 'fill:,columns:' -n 'echo_fill' -- "$@"); then
		exit 1
	fi
	eval set -- "$OPTS"

	while true; do
		case "$1" in
			-f | --fill)
				fill="${2:0:1}"
				shift 2
				;;
			-c | --columns)
				columns="$2"
				shift 2
				;;
			-n)
				newline=0
				shift
				;;
			--)
				shift
				break
				;;
			*)
				exit 1
			;;
		esac
	done
	input="$*"

	echo -n "$input"
	for ((i = ${#input}; i < columns; i++)); do
		echo -n "$fill"
	done
	((newline)) && echo
}
