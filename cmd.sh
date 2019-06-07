(
    check-error() {
        bash_source=$1 line_no=$2
        echo "$bash_source: $line_no"
        trap : ERR
        sleep 2
        exit 1
    }
    trap 'check-error $BASH_SOURCE $LINENO' ERR

    module=$1
    [ "$BASH_SOURCE" == "cmd.sh" ] || cd $( dirname $BASH_SOURCE )
    cmd_dir_path="scripts/cmd"
    modules=$( ls $cmd_dir_path )
    [ "$( echo "$modules" | grep "^$module$" )" == "" ] && {
        echo "$modules" | grep -v "^_"
    } || {
        args_=$@ args=$( echo $@ | cut -d " " -f 2- )
        cmd=". $cmd_dir_path/$module/init.sh"
        [ "$args_" == "$args" ] && $cmd "" || $cmd $args
    }
)
