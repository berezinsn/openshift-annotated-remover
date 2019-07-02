#!/bin/bash

#Path to oc bin (determine full oc bin path for crontab)
oc_path="/usr/local/bin/oc"

#Need to replace below string with SA token for API authorize
${oc_path} login https://openshift.test.cloud:8443 --insecure-skip-tls-verify=true --token XWMId2HlZtp18g > /dev/null

#For with list of projects in oc cluster and substitution all over the spaces with # character 
for name in `${oc_path} get namespace -o template --template='{{ range .items }}{{ .metadata.name }} {{ index .metadata "annotations" "someannotations/replace_it" }} {{ .metadata.creationTimestamp}} {{ "\n" }} {{ end }}'| sed 's/ /#/g'`;
do
  #Trimming "date" without Z character for convert it at the next step
  date=$(echo $name | sed 's/^\(.*\).$/\1/' | awk -F# '{print $NF}' | sed 's/Z//g');
  
  #Calculating current "date"
  cur_date=`date -u '+%s'`
  
  #Convert "date" of existing projects
  prj_date=`date -u -d "$date" '+%s'`
  
  #Diff between existing time and project life time
  time=$(( $cur_date - $prj_date  ))
  
  #Grep UNPAID annotation & set of unpaid project ttl
  if [[ "$name" =~ "UNPAID" && ${time} -ge 86400 ]];then

  #Reverse substitution of spaces for correct using of awk
  rm_prj=$(echo $name | sed 's/#/ /g' | awk '{print $1}');

  #Total remove of unpaid projects and writing deletion time corresponding prj_name into logfile
  out=`${oc_path} delete project $rm_prj`
  fi
done

