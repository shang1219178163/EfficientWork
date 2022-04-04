#!/bin/sh
#!/bin/bash
#!/bin/zsh


#add tag and push.sh

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}


#addTag + version
function addTag_by_version(){
    local version=$1
    echo "--- version: $version ---"

    commitID=`git log -1 --pretty=%h`
    commitMessage=`git log -1 --pretty=format:"%s"`
    echo "--- commitID: $commitID ---"
    echo "--- commitMessage: $commitMessage ---"
    echo "--- Step: add tag to local reposit：$commitID - $commitMessage---"
#    echo "git tag ${version} $commitID -m \"$commitMessage\""
    git tag ${version} $commitID -m "$commitMessage" || exit 1

    echo "--- Step: push tag to remote reposit ---"
    git push origin ${version} || exit 1

    echo "--- Step: finished ！---"
}


#解析 pubspec.yaml 添加 tag
function addTag_by_yaml(){
    eval $(parse_yaml pubspec.yaml "yaml_")
    echo "--- version: $yaml_version ---"
    
    addTag_by_version $yaml_version
}


addTag_by_yaml
