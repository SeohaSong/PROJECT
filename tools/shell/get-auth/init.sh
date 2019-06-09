option=$1; dir_path=$2
[ "$option" == "-t" -a "$dir_path" != "" ] || {
    echo "shs enroll -t <target directory path>"
    return 0
}    
[ -f "$dir_path"/*.pem ] || return 0

cp -r "$dir_path" ~
dir_name=$( basename "$dir_path" )
chmod 600 ~/"$dir_name"/*.pem
eval $(ssh-agent) > /dev/null
for val in $( ls ~/"$dir_name"/*.pem )
do
    ssh-add $val 2> /dev/null
done
rm -r ~/"$dir_name"

unset dir_path
unset dir_name
