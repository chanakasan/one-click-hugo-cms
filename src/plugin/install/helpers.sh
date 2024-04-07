start() {
  echo " Installing - $this_plugin_name"
}

uninstall_if() {
  if has_arg "_rm" "$@"; then
    echo " Uninstalling - $this_plugin_name"
    remove_from_bashrc
    echo " done"
    echo
    exit 0
  fi
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

has_arg() {
  local name="$1"
  local list="${@:2}"
  for arg in "$list"; do
    if [[ "$arg" == *"$name"* ]]; then
      return 0
    else
      return 1
    fi
  done
}
