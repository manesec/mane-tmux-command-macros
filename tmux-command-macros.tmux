#!/usr/bin/env bash

# This script Original idea is from @Neo-Oli 's Project
# https://github.com/Neo-Oli/tmux-text-macros
# A lot of code change and mod by @manesec

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

tmux_macros() {
    export manetest="manetesting"
    if [ "$1" = "-r" ];then
        set -f
        cd $maros_dir

        local BASEDIR=$(dirname "$0")
        local selected=$(find . -type f -iname "*.json" | fzf )        

        # if not select ...
        if [ -z "$selected" ];then
            exit 0
        fi

        # using jq to check format if have error
        if jq -c '.' "$selected" >/dev/null 2>&1 ; then
            true
        else
            echo "[Error] Failed to parse JSON, or got false/null"
            jq -c '.' "$selected"
            read -p "[press Enter to exit]"
            exit 0
        fi

        # load require into env
        for line in $(jq -c '.[]| .[]|=@base64' "$selected"); do 
            local read_funs=$(echo $line | jq -r 'keys[]')
            local read_value=$(echo $line | jq -r '.[]')
            if [ $read_funs = "require" ]; then
                export_var=$(echo $read_value | base64 -d);
                export $export_var=""
                read -p "Enter $export_var: " $export_var
            fi
        done;
       
        # save env and prepear to run
        selected=$(echo "$maros_dir/$selected" | base64 -w 0)

        random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
        randomName="tmc-runner-$random"

        env_file="/tmp/.$randomName.env"
        env > $env_file

        tmux new-session -d -s $randomName bash "$BASEDIR/tmux-command-runner.sh" "$PANE" "$selected" "$env_file"
        
    else
        if [ "$window_mode" = "vertical" ];then
            command="tmux split-window -v"
        elif [ "$window_mode" = "full" ];then
            command="tmux new-window -n Macros"
        else
            command="tmux split-window -h"
        fi
        tmux bind "$keybind" run-shell "$command \"PANE='#{pane_id}' $0 -r\""
    fi
}

maros_dir=$(get_tmux_option "@tcm-marod-dir" "$HOME/.tmux/plugins/tmux-command-macros/custom-macros")
window_mode=$(get_tmux_option "@tcm-window-mode" "vertical")
keybind=$(get_tmux_option "@tcm-keybind" "/")
tmux_macros $@
