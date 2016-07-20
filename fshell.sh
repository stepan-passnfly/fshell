#!/usr/bin/env bash
# include as . /path/to/fshell.sh this works in
#
# comment standard per function:
# name:
# usage:
# desc:
# usage as:
# params:
# return:

# set default lang to scripts only use english 
# by default in the servers or some issues will occur.
export LANG="en_US.UTF-8"
# name: space_fill()
# usage: space_fill [total length expected] [value to space fill] [side left|right]
# desc: fill with left or right spaces to complete length expected. Remember "quotes in the call"
# example: foovar="$(space_fill 12 left 'string' )"; echo "$foovar" 
# params: int len, string <left|right>, string value
# return: string with the spaces fill expected
space_fill()
{
    len=$1
    shift
    side=$1
    shift
    value="$@"
    len=$(expr $len - ${#value})
    spaces=''
    x=0
    while [ $x -lt $len ]; do
        spaces="$spaces "
        x=$(expr $x + 1)
    done
    side=$(lower $side)
    if [[ $side == 'left' ]]; then
        echo "${spaces}${value}"
    else
        echo "${value}${spaces}"
    fi
}

# name: zero_fill()
# usage: zero_fill [total length expected] [value to zero fill]
# desc: fill with left zeroes to complete length expected.
# example: foovar=$(zero_fill 3 1)
# params: int len, int value
# return: string only digit with the length required
zero_fill()
{
    value=$2
    len=$(expr $1 - ${#value})
    zeroes=''
    for i in $(seq $len); do
        zeroes=${zeroes}'0'
    done
    echo "${zeroes}${value}"
}

# name: timestamp()
# usage: timestamp
# desc: get standard timestamps
# usage as: my_ts=$(timestamp)
# params: none
# return: string with "+%Y-%m-%d %H:%M:%S"
timestamp()
{
    echo $(date "+%Y-%m-%d %H:%M:%S")
}

# name: get_date()
# usage: get_date
# desc: get standard no spaces get_date
# usage as: now=$(get_date)
# params: none
# return: string with "+%Y-%m-%d"
get_date()
{
    echo $(date "+%Y-%m-%d")
}

# name: usage()
# usage: usage <message help>
# desc: exit the script and display message
# usage as: usage <message>
# params: string
# return: exit or none
usage()
{
    echo "Usage: $@"
    exit 1
}

exit_message()
{
    echo $@
    exit 1
}

# name: check_for_cli_args()
# usage: check_for_cli_args [args length expected] [exit message for usage display] [array args]
# desc: valides the args lengs required to works in the script calls
# usage as: check_for_cli_args 2 "<val_1> <val_2> $@"
# params: int argsc, string msg
# return: exit if fail or none.
check_for_cli_args()
{
    argsc=$1
    shift
    message=$1
    shift
    [[ $# -lt $argsc ]] && usage $message
}

# name: continue_question()
# usage: continue_question
# desc: this function stop execution process and interact with executor for continue or not
# returns 0 to continue and 1 if not
# usage as: continue_question; [[ $? -eq 0 ]] && continue || exit 0
# params: none
# return: unsigned int
continue_question()
{
    while [ true ]; do
        echo -e " Do you want continue? (y/n)? \c "
        read r
        case $r in
            y) return 0 ;;
            n) return 1 ;;
            *) echo "Use: y/n"
               sleep 1 ;;
        esac
        clear
    done
}

# name: require_user()
# usage: require_user user1 user2 ... userN
# desc: if the user who launches the script not be in the list stop the script
# usage as: requiere_user user ... userN
# params: string $@
# return: none or exit.
require_user()
{
    sw=0
    for user in $@; do
        id |awk '{print $1}'| grep $user > /dev/null 2>&1
        [[ $? -eq 0 ]] && sw=1
    done
    if [ $sw -eq 0 ]; then
        echo -e " you must be one of these users ($@)."
        exit 1
    fi
}

# name: trim()
# usage: trim $string_to_trim
# desc: this trim white space both side of string
# usage as: clean_var=$(trim " hola mundo ") $clean_var="hola mundo"
# params: string
# return: string
trim()
{
    echo "$@" | sed -e 's/^ *//g' -e 's/ *$//g'
}

# name: rtrim()
# usage: rtrim $string_to_trim
# desc: this trim white space right side of string
# usage as: clean_var=$(rtrim " hola mundo ") $clean_var=" hola mundo"
# params: string
# return: string
rtrim()
{
    echo "$@" | sed 's/ *$//g'
}

# name: ltrim()
# usage: ltrim $string_to_trim
# desc: this trim white space left side of string
# usage as: clean_var=$(ltrim " hola mundo ") $clean_var="hola mundo "
# params: string
# return: string
ltrim()
{
    echo "$@" | sed 's/^ *//g'
}

# name:lower()
# usage: lower string
# desc: make strings lower case
# usage as: $(lower string)
# params: string
# return: string
lower()
{
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

# name: upper()
# usage: upper string
# desc: make strings upper case
# usage as: $(upper string)
# params: string
# return: string
upper()
{
    echo "$@" | tr '[:lower:]' '[:upper:]'
}

# name: file_exist()
# usage: file_exist [file_path]
# desc: check if exist file passed as param.
# usage as: call as $() shell exec
# params: string
# return: string
file_exist()
{
	[[ -f $1 ]] && echo 'YES' || echo 'NOT'
}

# name: ceil()
# usage: ceil [float]
# desc: ceiling float number.
# usage as: call as $() shell exec
# params: float
# return: integer
ceil()
{
	echo $(expr ${1/.*} + 1)
}

# name: floor()
# usage: floor [float]
# desc: to floor float number.
# usage as: call as $() shell exec
# params: float
# return: integer
floor()
{
	echo $(expr ${1/.*})
}

# name: running()
# usage: running "param"
# desc: check if process is running.
# usage as: call as $(running process_pattern) shell exec
# params: string
# return: string
running()
{
	ret=$(ps -ef |grep -i "$1" |grep -v grep|wc -l |tr -d ' ')
	[[ $ret -gt 0 ]] && echo 'YES' || echo 'NOT'
}

# name: iam_running()
# usage: iam_running
# desc: check if self process is running.
# usage as: call as $(iam_running) shell exec
# params: None
# return: string
iam_running()
{
    procs=0
    for pid in $(ps -ef |grep $0 |grep -v grep|awk '{print $2}'); do
        aux=$(ps -ef |grep $0 |grep -v grep|awk '{print $3}' |grep $pid |wc -l |tr -d ' ')
        [[ $aux -eq 0 ]] && procs=$(expr $procs + 1)
    done
	[[ $procs -gt 1 ]] && echo 'YES' || echo 'NOT'
}


# name: find_string_in_file() 
# usage: find_string_in_file string_pattern file_to_search
# desc: find string in a file both passed as argument.
# usage as: call as $() shell exec
# params: string, file
# return: string
find_string_in_file()
{
	if [[ -f $2 ]]; then
		grep -v "^#" $2 | grep -i "$1" > /dev/null 2>&1 
		[[ $? -eq 0 ]] && echo 'YES' || echo 'NOT'
	else
		echo 'NOT'
	fi
}

# name:get_os_name()
# usage: get_os_name
# desc: returns os name string
# usage as: $(get_os_name)
# params: None
# return: string
get_os_name()
{
    echo $(uname -s)
}

# name: get_color()
# usage: get_color [black|red|green|yellow|blue|magenta|cyan|white]
# desc: return a color string
# usage as: $(get_color color)
# params: string
# return: string
get_color()
{
    case "$1" in
        "black")
            color="\033[0;30m" 
            ;;
        "red")
            color="\033[0;31m"
            ;;
        "green")
            color="\033[0;32m"
            ;;
        "yellow")
            color="\033[0;33m"
            ;;
        "blue")
            color="\033[0;34m"
            ;;
        "magenta")
            color="\033[0;35m"
            ;;
        "cyan")
            color="\033[0;36m"  
            ;;
        "white")
            color="\033[0;37m" 
            ;;
        *)
            color="\033[0m"
            ;;
    esac
    echo $color
}

# name: color_string()
# usage: color_string color str
# desc: pirnt string with color
# usage as: $(color_string red "colored as red")
# params: color_name, string_to_colored
# return: string
color_string()
{
    color=$(get_color $1)
    no_color=$(get_color none)
    str=$2
    if [[ $(get_os_name) == 'Linux' ]]; then
        echo -e "${color}${str}${no_color}"
    else
        echo "${color}${str}${no_color}" 
    fi
}
