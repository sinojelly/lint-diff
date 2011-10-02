#!/bin/bash
# Usage: lint-diff.sh --baseline commit-id or file --target target-name -- [lint options] file
#        if commit-id is null (invalid commit-id), no basefile.

# 下面方式，一般可以取得当前脚本的路径
#LINT_DIFF_DIR=`dirname $0`
#LINT_DIR=../..

BASELINE=
TARGET=
SRCFILE=
TMPDIR=/tmp/lint-diff

# -e判断目录是否存在
if [ ! -e $TMPDIR ]; then
	mkdir $TMPDIR
fi

# 参数处理
while true ; do
	case "$1" in
		-b|--baseline) BASELINE=$2; shift 2;;
		-t|--target)   TARGET=$2; shift 2 ;;
		--) shift ; break ;;
		*) echo "Parameter error!" ; exit 1 ;;
	esac
done

# 取得最后一个参数
# the last param is the file to lint.
SRCFILE=${!#}

# dirname取得目录名
TARGET_DIR=`dirname $TARGET`

# basename取得文件名，如果$TARGET后缀是.xml，下面命令去掉该后缀
TARGET_FILE=`basename $TARGET .xml`

# 函数调用结束，回到之前的目录。不会因为cd而出错
# param1: from which dir
function get_git_path()
{
	cd $1
	while true ; do
		if [ "`ls -a | grep .git`" = ".git" ]; then
			echo `pwd`/.git
			break
		else
			cd ..
			if [ "`pwd`" = "/" ]; then
				echo ""
				break
			fi
		fi
	done
}

# param1: file
# param2: git-path
function get_filepath_rel_to_git()
{
    git_dir=${2/.git/}
	file_path=`get_fullpath $1`
	echo ${file_path/$git_dir/}
}

if [ -e $BASELINE ]; then
	BASEFILE=$BASELINE
else
    GIT_PATH=`get_git_path $TARGET_DIR`
	FILE_PATH=`get_filepath_rel_to_git $SRCFILE $GIT_PATH`
	BASEFILE=$TMPDIR/$FILE_PATH
	rm -f $BASEFILE
	# checkout的文件必须是相对于git库根目录的路径，--work-tree指定的文件夹必须存在
	git --work-tree=$TMPDIR --git-dir=$GIT_PATH checkout $BASELINE -- $FILE_PATH 2>/dev/null
fi


echo "BASELINE: $BASELINE"
echo "TARGET  : $TARGET" 
echo "SRCFILE : ${!#}"
echo "BASEFILE: $BASEFILE"
echo "COMMAND : $*"

# 指定diff输出的格式，有差异的组，输出起始行号和行数，后面的换行使得输出结果也是一个组的信息一行
FILTER=`diff --changed-group-format='%dF %dN
' --unchanged-group-format='' $BASEFILE $SRCFILE | awk '{printf "line &gt; "$1-1" and line &lt; "$1+$2}'`

# 把所有的&替换为\& 
FILTER=${FILTER//&/\\&}

if [ -z "$FILTER" ]; then
FILTER="*"
fi

# sed替换
sed "s/===line-filter===/$FILTER/g" $LINT_DIFF_DIR/lint-diff.xsl > $TARGET_DIR/$TARGET_FILE.xsl

$LINT_DIR/lint-nt.exe -i$LINT_DIR_WIN env-xml.lnt $* > $TARGET

# sed在第1行后面增加一行内容(a\)
sed -i "1a\<?xml-stylesheet type=\"text\/xsl\" href=\"$TARGET_FILE.xsl\"?>" $TARGET
