#!/bin/bash
# ʹ�÷������޸������ĸ����������������OLD_WORK_DIR���޸Ĳ����ĸ澯

# ����һ���µ�shell�ű�ʱ��������shell��û��export�ı����ͺ�������Ч��
export LINT_DIR=/d/PC-Lint9

# lint-nt.exe��windows����-iָ������·��ʱ������windows·����shell��ѵ���\����ת���ַ������Ա�����\\ 
export LINT_DIR_WIN=d:\\PC-Lint9   

export LINT_DIFF_DIR=/d/PC-Lint9/lint-diff

export OLD_WORK_DIR=/d/PC-Lint9/test/old
export NEW_WORK_DIR=/d/PC-Lint9/test/new

#Usage: get_fullpath relative_path
function get_fullpath()
{
    # �ж��Ƿ����˲���
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

# export����
export -f get_fullpath
