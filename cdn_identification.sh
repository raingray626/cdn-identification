for d in $(sort -u ${1})
do
    check_domain=$(host -t cname $d | grep 'is an alias for' | awk '{print $6}' | gawk 'BEGIN{FS="."; OFS="."} {print $(NF-2),$(NF-1)}')
    if [[ -z $check_domain ]]; then
        continue
    fi

    check_status=$(jq -r ".[\"${check_domain}\"].name" ./cdn.json)
    if [[ $check_status != 'null' ]]; then
        echo $d,$check_status
    else
        echo "$d,$check_domain,$check_status"
    fi
done
