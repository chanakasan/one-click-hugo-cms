start() {
  echo " Installing - $this_plugin_name"
}

validate() {
  require_param "this_plugin_name"
  require_param "bashrc"
  require_param "this_start_text"
  require_param "this_end_text"
  require_param "this_middle_text"
}

finish() {
  echo " done"
  echo
}

remove_from_bashrc() {
  sed -i '/#'$this_start_text'/,/#'$this_end_text'/{d}' $bashrc
}

copy_to_bashrc() {
  local content="$1"
  if [ -z "$this_middle_text" ]; then
    echo " copy_to_bashrc error"
    exit 1
  fi
  echo "" >> $bashrc
  echo "#$this_start_text" >> $bashrc
  echo "$this_middle_text" >> $bashrc
  echo "#$this_end_text" >> $bashrc
}

require_param() {
  local var_name="$1"
  local var_value="${!var_name}"
  if [ -z "$var_value" ]; then
    echo " required param is not set: $var_name"
    echo " aborting"
    echo
    exit 1
  fi
}
