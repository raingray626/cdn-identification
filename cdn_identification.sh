for d in $(sort -u ${1})
do
    check_status=$(jq -r ".[\"${d}\"].name" ./cdn.json)
    if [[ $check_status != 'null' ]]; then
        echo $d,$check_status
    else
        echo "$d,$check_status"
    fi
done
