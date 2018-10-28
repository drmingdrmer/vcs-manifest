#!/bin/sh

fn=$1
url="$2"

url="${url#http*://}"
domain="${url%%/*}"
uri="${url#*/}"

user="${uri%%/*}"
left="${uri#*/}"

repo="${left%%/*}"

echo $url
echo $domain
echo $uri
echo $user
echo $repo
echo $left

case $domain in
    github.com)
        remote=github
        ;;
    bitbucket.org)
        remote=bitbucket
        ;;
    *)
        echo unknown domain: $domain
        exit 1
        ;;
esac

line=$(
cat <<-END
    <project remote="$remote" name="$user/$repo" />
END
)

cat $fn | awk -v line="$line" '
/<!--add-->/ {
    print line
}

{
    print $0
}
' > tmp

mv tmp $fn

