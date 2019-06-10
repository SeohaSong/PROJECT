raise-e() {
    echo "[SHS] Error in '$1: $2'"
    case $3 in
    1) echo "[SHS] Main function error" ;;
    2) echo "[SHS] Unknown option '$4'" ;;
    3) echo "[SHS] Require argument to option '$4'" ;;
    4) echo "[SHS] Number of arguments mismatch (target: $4)" ;;
    esac
    exit 1
}
set-argument() {
    trap 'raise-e $BASH_SOURCE $LINENO' ERR
    opts=$1 n_arg=$2 args=( "$@" )
    args[0]='' args[1]=''
    args=( ${args[@]} )
    idx=0 max=${#args[@]} cmds=()
    while [ $idx -lt $max ]; do
        arg=${args[$idx]}
        case $arg in
        --*) args[$idx]="" arg=${arg#'--'} ;;
        *) break ;;
        esac
        opt=( $( echo "$opts" | grep "\-\-$arg" || : ) )
        case "$opt" in
        "") raise-e $BASH_SOURCE $LINENO 2 $arg ;;
        *)
            case ${opt[1]} in
            0) cmds+=( $arg=$arg ) ;;
            1)
                idx=$(( $idx+1 ))
                val=${args[$idx]}
                ! [[ $val =~ ^--|^$ ]] || raise-e $BASH_SOURCE $LINENO 3 $arg
                args[$idx]="" cmds+=( $arg=$val )
            ;;
            esac
        ;;
        esac
        idx=$(( $idx+1 ))
    done
    n_main=$(( $max-$idx ))
    [ $n_arg == n -a $n_main -gt 0 -o $n_arg != n -a $n_main == $n_arg ] \
    || raise-e $BASH_SOURCE $LINENO 4 $n_arg
    echo $( for cmd in ${cmds[@]}; do echo $cmd; done ) args="'${args[@]}'"
    [ $n_arg != 0 ] || { echo 'main'; return; }
    echo 'for arg in $args; do main $arg; done'
}
main() {
    dir_path=$1 args=( "$@" )
    args[0]=''
    args=( ${args[@]} )
    modules=$( ls "$dir_path" | grep -v main.sh )
    case $( echo "$modules" | grep ^$args$ ) in
    "")
        echo "[SHS]"
        echo "$modules" | grep -v ^_
    ;;
    *)
        path="$dir_path/$args/main.sh"
        args[0]=""
        . "$path" "${args[@]}"
        unset path
    ;;
    esac
    unset modules
    unset dir_path
    unset args
}
main "$( dirname $BASH_SOURCE )" $@
unset -f main
unset -f argument
unset -f raise-e
