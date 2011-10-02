#!/bin/bash
# 使用方法：修改下面四个变量，会检查相对于OLD_WORK_DIR的修改产生的告警

# 调用一个新的shell脚本时，进入子shell，没有export的变量和函数就无效了
export LINT_DIR=/d/PC-Lint9

# lint-nt.exe是windows程序，-i指定绝对路径时必须用windows路径，shell会把单个\当作转义字符，所以必须用\\ 
export LINT_DIR_WIN=d:\\PC-Lint9   

export LINT_DIFF_DIR=/d/PC-Lint9/lint-diff

export OLD_WORK_DIR=/d/PC-Lint9/test/old
export NEW_WORK_DIR=/d/PC-Lint9/test/new

#Usage: get_fullpath relative_path
function get_fullpath()
{
    # 判断是否传入了参数
    if [ -z $1 ]
    then
        return 1
    fi 
    relative_path=$1
	if [ -d relative_path ]; then
		tmp_path1=$relative_path
		tmp_path2=
	else
		tmp_path1=`dirname $relative_path`
		tmp_path2=`basename $relative_path`
	fi
	
    tmp_fullpath1=$(cd $tmp_path1 ;  pwd)

    echo ${tmp_fullpath1}/${tmp_path2}
    return 0
}

# export函数
export -f get_fullpath
