start() {
  echo " Installing - $this_plugin_name"
}

init_script_vars() {
  this_bashrc="$HOME/.bashrc"
  this_name=$plug_short_name
  this_plugin_name=$this_name.plugin
  this_plugin_path=$(get_root_path)/plugins/$this_plugin_name
  this_start_text='__nex_'$this_name'_start'
  this_end_text='__nex_'$this_name'_end'
  this_middle_text="source $this_plugin_path/src/entry.sh"
}

get_root_path() {
  echo $HOME/dotfiles
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
  validate_user_vars
  init_script_vars
  validate_script_vars
}

validate_user_vars() {
  require_param "plug_short_name"
}

validate_script_vars() {
  require_param "this_name"
  require_param "this_plugin_name"
  require_param "this_plugin_path"
  require_param "this_bashrc"
  require_param "this_start_text"
  require_param "this_end_text"
  require_param "this_middle_text"
}

finish() {
  echo " done"
  echo
}

remove_from_bashrc() {
  sed -i '/#'$this_start_text'/,/#'$this_end_text'/{d}' $this_bashrc
}

copy_to_bashrc() {
  local content="$1"
  if [ -z "$this_middle_text" ]; then
    echo " copy_to_bashrc error"
    exit 1
  fi
  echo "" >> $this_bashrc
  echo "#$this_start_text" >> $this_bashrc
  echo "$this_middle_text" >> $this_bashrc
  echo "#$this_end_text" >> $this_bashrc
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
