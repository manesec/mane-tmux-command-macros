# tmux-command-macros

The original code base on [tmux-text-macros](https://github.com/Neo-Oli/tmux-text-macros/tree/master), and [@manesec](https://github.com/manesec) made a lot of changes.

The original idea was to integrate some of the more useful tools for my tmux functionality, hence the name `tmux-command-macros`.

> 既然找不到想要的工具，那也只能自己写了。 QAQ

Since I have to do repetitive commands all the time, which bores me to death, I was looking for a macros on tmux. 
But, Unfortunately, there were no good plugins to be found, so I decided to make my own. 

`tmux-command-macros` is a tmux plugin. It let's you define a bunch of macros, from which you can choose by pressing `Prefix + /`.

![Demo](https://raw.githubusercontent.com/manesec/tmux-command-macros/master/demo.gif)

By default it contains a demo script.

![Demo](https://raw.githubusercontent.com/manesec/tmux-command-macros/master/demo1.gif)

*Imagine you're a hacker.*

**Note:** We don't provide any scripts, if interested just look at my [other project](https://github.com/manesec/mane-tmux-macros).

**Note:** Current are not support to recording the macros.

## Requirements

* `fzf`
* `jq`

## Installation

1. clone repository to `~/.tmux/plugins/`, change premission
2. add `run-shell ~/.tmux/plugins/tmux-command-macros/tmux-command-macros` to your `~/.tmux.conf`
3. run `tmux source ~/.tmux.conf` to enable the changes

```bash
# step 1
sudo apt install -y fzf jq
git clone https://github.com/manesec/tmux-command-macros.git ~/.tmux/plugins/tmux-command-macros

chmod +x ~/.tmux/plugins/tmux-command-macros/tmux-command-macros.tmux
chmod +x ~/.tmux/plugins/tmux-command-macros/tmux-command-runner.sh

# step 2 
# manually add `run-shell ~/.tmux/plugins/tmux-command-macro/tmux-command-macro` in your tmux.

# step 3
tmux source ~/.tmux.conf
```

## Configuration

You can add your own custom macros to `~/.tmux/plugins/tmux-command-macros/custom-macros`. 

Example on tmux config: 

```bash
$ cat ~/.tmux.conf

# setup tmux-text-macros                
set -g @tcm-window-mode vertical
run-shell ~/.tmux/plugins/tmux-command-macros/tmux-command-macros.tmux
```

## Limitations

+ Not support to recording the macros.
+ Not able interactive the tmux.

## Options in tmux config

#### @tcm-marod-dir (default: "$HOME/.tmux/plugins/tmux-command-macros/custom-macros")

Tell where is macron location.

#### @tcm-window-mode (default: "vertical")

How to split the tmux window
* `horizontal`
* `vertical`
* `full` -> new window

#### @tcm-keybind (default: "/")

Setting the keybind for tmux-text-macros to execute.

## Macros

A Example Macros: 

```bash
[
    {"require":"mane"},
    {"require-from-cmd":"cd /Tools; export MANE=$(fzf)"},

    {"send-string":"hi, you are input some text: "},
    {"send-from-cmd":"echo $mane"},
    {"sleep":"1"},
    {"send-key":"C-c"},

    {"debug":"Hi, I am only show on your runner session"},

    {"send-string":"hi, test b64 working: "},
    {"send-from-cmd-b64":"ZWNobyAkbWFuZQo="},
    {"sleep":"1"},
    {"send-key":"C-c"},

    {"send-string":"I am kill your firefox"},
    {"run-command":"pkill firefox"},
    {"sleep":"1"},
    {"send-key":"C-c"},

    {"sleep":"30"}
]
```

As you can see, each one line is an action, you can define the actions you want.

Whenever you execute a Macros, a tmux session is automatically created.

### Macros Action

#### debug 

Just show in the runner-session message.

#### require

Require Variables from user input and save it to the environment variable.

For example: `{"require":"mane"}` and `{"send-from-cmd":"echo $mane"}`.

#### require-from-cmd

Pre-Run command.

It is very useful when in the user ui.

#### require-from-cmd-b64

Pre-Run command for b64.

#### sleep

sleep for 5 seconds.

#### send-key

send a raw key, `C-c` for `Ctrl + c`, `Enter` for `Enter key`.

> When specifying keys, most represent themselves (for example ‘A’ to ‘Z’). Ctrl keys may be prefixed with ‘C-’ or ‘^’, and Alt (meta) with ‘M-’. In addition, the following special key names are accepted: Up, Down, Left, Right, BSpace, BTab, DC (Delete), End, Enter, Escape, F1 to F20, Home, IC (Insert), NPage/PageDown/PgDn, PPage/PageUp/PgUp, Space, and Tab.

Reference:  [tmux's manual KEY BINDINGS](https://man.openbsd.org/OpenBSD-current/man1/tmux.1#KEY_BINDINGS)

#### send-string

Just send a string.

#### send-from-cmd

run command and sent it to tmux panel.

#### send-from-cmd-b64

run command for base64 format and sent it to tmux panel.

#### run-command

run command, but DO NOT sent it to tmux panel.

#### run-command-b64

run command for base64 format, but DO NOT sent it to tmux panel.

## Usage

Press `Prefix /` (normally `Ctrl+b /`) and choose a string by choosing it with the arrow keys or by entering a search string and press enter.
