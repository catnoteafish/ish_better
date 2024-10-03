#!/bin/bash
#特别感谢 https://blog.csdn.net/qq_57851190/article/details/128764070
if [ "$(uname)" == "Linux" ]; then
    if ! [ -f "/etc/alpine-release" ]; then
        echo "当前系统不是 Alpine Linux!"
        exit 1
    fi
else
    echo "当前系统不是 Linux!"
    exit 1
fi

echo "感谢使用此优化版本!"
echo "作者: Kasytano (https://github.com/catnoteafish/catnoteafish)"
echo "建议全程使用魔法加速!"
echo "警告! 此脚本会修改你的系统配置, 请确保你知道你在做什么!"
while true
do
    echo "是否继续?(y/n)\n>>"
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        exit 1
    else
        echo "无效的输入!\n>>"
    fi
done

echo "正在覆写配置文件..."
echo "" > etc/profile

# 换源
while true
do
    echo "换源? （默认使用: 清华源）(y/n)\n>>"
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        echo "# 中科大源\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community" >> /etc/apk/repositories
        echo "写入中..."
        echo "是否写入到启动脚本?(ISH在每次启动会换为初始源)(y/n)\n>>"
        read choice
        if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
        then
            echo 写入中...
            echo "echo \"# 中科大源\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community\" >> /etc/apk/repositories" >> etc/profile
            break
        elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
        then
            break
        else
            echo "无效的输入!\n>>"
        fi
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "正在更新软件包..."
apk update

echo "安装常用工具?(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        apk add --no-cache curl wget git vim git sudo
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "安装开发工具?(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        apk add python3 py3-pip go gcc clang gdb g++ libc-dev perl make cmake git
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "安装oh-my-zsh?(推荐)(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        #安装zsh
        apk add zsh
        #安装oh-my-zsh「采用gitee加速下载安装」：
        sh -c "$(wget -O- https://gitee.com/pocmon/mirrors/raw/master/tools/install.sh)"
        #编辑一下/etc/passwd文件，将 zsh 设置为默认 Shell
        vi /etc/passwd
        #把root用户的那一行最后的/bin/ash修改为/bin/zsh
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "安装neovim?(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        apk add neovim vim
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "配置ssh?(推荐)(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        apk add openssh
        # 生成公私钥
        echo "正在生成公私钥...(此过程耗时极久 不是脚本卡住了!)"
        ssh-keygen -A
        # 默认情况下，linux是禁止通过ssh访问root的，需要先修改sshd_config文件
        echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
        echo "启动ssh服务..."
        /usr/sbin/sshd
        break;
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "启用后台保活?(y/n)\n>>"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        echo "请注意 20s后会申请定位权限 你的数据不会保存 仅用于保活!(如果没有这个选项/点错了 请在设置->隐私->位置里设置为“始终允许)"
        cat /dev/location > /dev/null &
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done

echo "挂载目录?(y/n)"
while true
do
    read choice
    if [ $choice = 'y' ] || [ $choice = 'Y' ] || [ $choice = 'yes' ] || [ $choice = 'Yes' ];
    then
        echo "将挂载目录 请选择一个目录!"
        sleep 10
        mkdir -p /mnt/device && sudo mount -t ios . /mnt/device
        echo "文件夹已挂载到/mnt/device"
        break
    elif [ $choice = 'n' ] || [ $choice = 'N' ] || [ $choice = 'no' ] || [ $choice = 'No' ];
    then
        break
    else
        echo "无效的输入!\n>>"
    fi
done