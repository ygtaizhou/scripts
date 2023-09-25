#!/usr/bin/env bash

nginx_path=/usr/local/nginx
config_path=$nginx_path/conf/sites-enabled

bare_path=0
dirname=""

check_arguments() {
  if [ "$server_name" == "" ];then
    echo require server name
    exit 1;
  fi
}

set_default_dirname() {
  if [ $bare_path -eq 0 ] && [ "$dirname" == ""  ];then
    dirname=public
  fi
}

create_config_file() {
  file="$config_path/$server_name.conf"
  template_file="$config_path/default"
  if [ -f $file ];then
    echo "file $file exists"
    return
  fi
  cp $template_file $file
  sed -i '' -e "s|\[SERVER_NAME\]|${server_name}|g; s|\[ROOT_PATH\]|${root_path}|g" $file

  echo "config file located: $file"

  restart_nginx
}

create_directory() {
  if [ ! -d $root_path ];then
    mkdir -p $root_path
  fi
}

restart_nginx() {
  echo restart nginx...
  sudo $nginx_path/sbin/nginx -s reload
}

add_record_to_hosts_file() {
  local file=/etc/hosts
  local local_ip=127.0.0.1

  record_count=`grep -cEi "$local_ip[[:space:]]+$server_name$" $file`
  if [ $record_count -ne 0 ];then
    return
  fi

  local section_header='# Added by script nginx-create(2c0719)'
  local section_footer='# End of section(2c0719)'

  line_num=`sed -n "/$section_footer/=" $file`

  if [ "$line_num" == '' ];then
    sudo sed -i '' "$ a\\
$section_header \\
$local_ip $server_name\\
$section_footer \\
" $file
      return
  fi

  sudo sed -i '' "$line_num i\\
$local_ip $server_name\\
" $file
}

while getopts n:d:b flag
do
  case "${flag}" in
    n) server_name=${OPTARG};;
    b) bare_path=1;;
    d) dirname=${OPTARG};;
  esac
done

check_arguments

set_default_dirname

root_path=/var/www/$server_name
if [ "$dirname" != "" ];then
  root_path=$root_path/$dirname
fi

create_directory

create_config_file

add_record_to_hosts_file