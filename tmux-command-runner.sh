#! /bin/bash
# this script write by @manesec.

tmux_macros_run_command(){
    local read_funs=$1;
    local read_value=$(echo $2 |base64 -d);

    case $read_funs in  
        debug ) 
            echo "[debug] $read_value"
            ;;  
        sleep ) 
            echo "[sleep] $read_value"
            for i in $(seq 1 $read_value); do
                echo `expr $read_value - $i`
                tmux rename-window -t $PANE "[$remain-`expr $read_value - $i + 1`s]"
                sleep 1
            done
            ;;  
        send-key ) 
            echo "[send-key] $read_value"
            tmux send-keys -t "$PANE" $read_value
            ;;  
        send-string ) 
            echo "[send-string] $read_value"
            tmux send-keys -t "$PANE" -l "" "$read_value"
            ;;  
        run-command ) 
            echo "[run-command] $read_value"
            cmd_value=$(eval $read_value)
            ;;  
        run-command-b64 ) 
            echo "[run-command-b64] $read_value"
            cmd_value=$(echo "$read_value" | base64 -d)
            cmd_value=$(eval $cmd_value)
            ;;  
        send-from-cmd ) 
            echo "[send-from-cmd] $read_value"
            cmd_value=$(eval $read_value)
            tmux send-keys -t "$PANE" -l "" "$cmd_value"
            ;;  
        send-from-cmd-b64 ) 
            echo "[send-from-cmd-b64] $read_value"
            cmd_value=$(echo "$read_value" | base64 -d)
            cmd_value=$(eval $cmd_value)
            tmux send-keys -t "$PANE" -l "" "$cmd_value"
            ;;  
    esac
}

sh_loader(){

    echo "     ##      Mane Tmux Command Macros V0.1      ##"
    echo "    https://github.com/manesec/mane-tmux-command-macros"
    echo "-----------------------------------------------------------"
    
    PANE=$1
    selected=$(echo $2 | base64 -d)
    env_file=$3

    # load require into env if exist
    echo "[env] Reading from env $env_file ..."
    if [ -f $env_file ]; then
        while read -r LINE; do
            # Remove leading and trailing whitespaces, and carriage return
            CLEANED_LINE=$(echo "$LINE" | awk '{$1=$1};1' | tr -d '\r')

            if [[ $CLEANED_LINE != '#'* ]] && [[ $CLEANED_LINE == *'='* ]]; then
              export "$CLEANED_LINE"
            fi
        done < $env_file

        rm -f $env_file
    fi

    total=$(jq -c '.[]|.[]|=@base64' "$selected" | wc -l)
    current=0

    # send to run command
    echo "[main] Time to start ..."
    for line in $(jq -c '.[]| .[]|=@base64' "$selected") ; do 
        local read_funs=$(echo $line | jq -r 'keys[]')
        local read_value=$(echo $line | jq -r '.[]')

        # Calc process remain
        current=$((current+1))
        remain=`expr $total - $current`
        tmux rename-window -t $PANE "$remain"

        # Reading command
	tmux_macros_run_command $read_funs $read_value;

    done;

    # back to auto rename
    tmux set-option -t $PANE -w automatic-rename on
}

sh_loader $@
