(
    trap 'check-error $BASH_SOURCE $LINENO' ERR

    module=$1
    dir_path=$( dirname $BASH_SOURCE )/init
    modules=$( ls $dir_path )
    [ "$( echo "$modules" | grep "^$module$" )" == "" ] && {
        echo "$modules" | grep -v "^_"
    } || {
        args_=$@ args=$( echo $@ | cut -d " " -f 2- )
        cmd=". $dir_path/$module/init.sh"
        [ "$args_" == "$args" ] && $cmd "" || $cmd $args
    }
)
