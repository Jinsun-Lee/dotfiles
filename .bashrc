# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#------basic Setting--------------------------------------
alias bashrc='gedit ~/.bashrc'
alias ㅠㅁ녹ㅊ='gedit ~/.bashrc'
alias bashup='source ~/.bashrc'
alias ㅠㅁ노ㅕㅔ='source ~/.bashrc'
alias c='clear'
alias ㅊ='clear'
alias rma='rm -rf'
alias rma3='rm -rf build/ install/ log/'
alias python='python3'

#------GPU Setting--------------------------------------
export PATH=/usr/local/cuda-12.4/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64:$LD_LIBRARY_PATH
export PYTHONPATH=$HOME/.local/lib/python3.10/site-packages:$PYTHONPATH

alias cuda='watch -d -n 0.5 nvidia-smi'
alias GPU_TEST='python3 -c "import torch; print(f\"CUDA available: {torch.cuda.is_available()}\"); print(f\"GPU name: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else None}\")"'

CLEAN_GPU_MEMORY(){
  for i in $(ps aux | grep python | awk '{print $2}' | sort -u); do kill -9 $i; done
}

#-----ROS Setting-----------------------------------------
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash

qqq() {    
    sudo pkill -9 -f "rqt|gazebo|rviz|ign"
    sudo pkill -9 -f "ros2|gz|gazebo|ign|rqt | python3"
    
    sudo pkill -9 -f "ros2" 2>/dev/null
    sudo pkill -9 -f "/opt/ros/humble" 2>/dev/null
    
    sudo pkill -9 gzserver 2>/dev/null
    sudo pkill -9 gzclient 2>/dev/null
    sudo pkill -9 ign      2>/dev/null
    sudo pkill -9 gazebo   2>/dev/null

    sudo pkill -9 rviz2 2>/dev/null
    sudo pkill -9 rqt   2>/dev/null

    sudo pkill -9 -x robot_state_publisher 2>/dev/null
    sudo pkill -9 -x static_transform_publisher 2>/dev/null
    sudo pkill -9 -x spawner 2>/dev/null
    sudo pkill -9 -f controller_manager 2>/dev/null
    
    # 현재 사용자 홈 기준 workspace 프로세스 종료
    ps -u "$USER" -o pid,stat,cmd \
    | grep "$HOME/ros2_ws/install" \
    | grep -v grep \
    | awk '{print $1}' \
    | xargs -r kill -9
    
    # 중단된 grep ERROR|FATAL 프로세스 정리
    ps -u "$USER" -o pid=,stat=,command= | \
    awk '$2 ~ /T/ && $3 ~ /^grep/ && $0 ~ /\(ERROR\|FATAL\)/ {print $1}' | \
    xargs -r kill -9
}

#export AMENT_PREFIX_PATH=''
#export CMAKE_PREFIX_PATH=''

#git reset --hard HEAD~1
#git push -f origin master

source /usr/share/gazebo/setup.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

#eval "$(register-python-argcomplete3 ros2)"
#eval "$(register-python-argcomplete3 colcon)"

#-----Setting----------------------------------------
# Gazebo Fortress & NVIDIA RTX 4060 Settings
#export __NV_PRIME_RENDER_OFFLOAD=1
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
#export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
#export IGN_RENDER_ENGINE=ogre2
#qexport OGRE2_OPENGL_VERSION=3.3

export ROS_LOCALHOST_ONLY=1
#export ROS_DOMAIN_ID=8
#export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export CYCLONEDDS_URI=file:///home/jinsun/ros2_ws/env_snapshot/cyclonedds.xml


#export GZ_SIM_RESOURCE_PATH=$GZ_SIM_RESOURCE_PATH:/usr/share/gz/models
#export GZ_SIM_SYSTEM_PLUGIN_PATH=$GZ_SIM_SYSTEM_PLUGIN_PATH:/opt/ros/humble/lib
#export IGN_GAZEBO_SYSTEM_PLUGIN_PATH=$IGN_GAZEBO_SYSTEM_PLUGIN_PATH:/opt/ros/humble/lib
#export IGN_GAZEBO_RESOURCE_PATH=$IGN_GAZEBO_RESOURCE_PATH:/home/jinsun/ros2_ws/src/jetank_description/models

#cd ~/ros2_ws; qqq; colcon build --packages-select jetank_description --cmake-clean-cache; bashup; ros2 launch jetank_description gazebo.launch.py
#cd ~/ros2_ws; bashup; ros2 run rqt_gui rqt_gui --ros-args -r __ns:=/jetank -r /tf:=tf -r /tf_static:=tf_static
#alias aaa='cd ~/ros2_ws; qqq; bashup; ros2 launch jetank_description gazebo.launch.py 2>&1 | stdbuf -oL -eL grep -E "\[(ERROR|FATAL)\]"'
#alias kiki='cd ~/ros2_ws; qqq; colcon build --packages-select jetank_description --cmake-clean-cache; bashup; aaa'
alias kiki='qqq; rma3; colcon build; bashup; colcon build --packages-select simulation_pkg --symlink-install; bashup'
alias aaa='qqq; c; ros2 launch simulation_pkg parking_simulation.launch.py'

#export OPENAI_API_KEY=개인키로수정
#export RCUTILS_LOGGING_SEVERITY_THRESHOLD=ERROR

#git config --local user.name "이진선"
#git config --local user.email "이메일"

alias MOVE='ros2 service call /go std_srvs/srv/SetBool "{data: true}"'
alias STOP='ros2 service call /go std_srvs/srv/SetBool "{data: false}"'

export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/jinsun/ros2_ws/src/simulation_pkg/models

export EDITOR="code -w"
export VISUAL="code -w"

# sudo chmod 600 .gitlab/개인키.pem 도커로 접속하기 위해 필요
alias eeeeeeeeeee='ssh -i ~/ros2_ws/.gitlab/개인키.pem ubuntu@대체해야지'




# === SIM_CONNECT ===
# ROS2 + Gazebo EC2 시뮬레이션 연결 설정
# 로컬에서 실행하려면 이거 주석해
# MY_VPN_IP=$(ip a show tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
# if [ -n "$MY_VPN_IP" ]; then
#     export ROS_DOMAIN_ID=42
#     export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
#     export CYCLONEDDS_URI="<CycloneDDS><Domain><General><Interfaces><NetworkInterface address=\"${MY_VPN_IP}\"/></Interfaces></General><Discovery><Peers><Peer address=\"10.8.0.1\"/></Peers></Discovery></Domain></CycloneDDS>"
#     export GAZEBO_MASTER_URI="http://10.8.0.1:8888"
#     export GAZEBO_IP="$MY_VPN_IP"
# fi


