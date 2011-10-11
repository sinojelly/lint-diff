#!/bin/bash
# Usage: lint-diff.sh --baseline commit-id or file --target target-name -- [lint options] file
#        if commit-id is null (invalid commit-id), no basefile.


BASELINE=
TARGET=
SRCFILE=
TMPDIR=/tmp/lint-diff

if [ ! -e $TMPDIR ]; then
	mkdir $TMPDIR
fi

while true ; do
	case "$1" in
		-b|--baseline) BASELINE=$2; shift 2;;
		-t|--target)   TARGET=$2; shift 2 ;;
		--) shift ; break ;;
		*) echo "Parameter error!" ; exit 1 ;;
	esac
done

# the last param is the file to lint.
SRCFILE=${!#}

TARGET_DIR=`dirname $TARGET`

# get filename, ignore .xml suffix.
TARGET_FILE=`basename $TARGET .xml`

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
	# 1. specify the file path relative to git-dir to checkout. 2. there must be a --work-tree dir.
	git --work-tree=$TMPDIR --git-dir=$GIT_PATH checkout $BASELINE -- $FILE_PATH 2>/dev/null
fi


#echo "BASELINE: $BASELINE"
#echo "TARGET  : $TARGET" 
#echo "SRCFILE : ${!#}"
#echo "BASEFILE: $BASEFILE"
#echo "COMMAND : $*"

if [ ! -e $BASEFILE ]; then
FILTER="*"
else
# output start-line-number lines-count for each diff group
FILTER=`diff --changed-group-format='%dF %dN
' --unchanged-group-format='' $BASEFILE $SRCFILE | awk 'BEGIN{printf "false"}{printf " or line &gt; "$1-1" and line &lt; "$1+$2}'`
fi

# replace & to \& 
FILTER=${FILTER//&/\\&}

sed "s/===line-filter===/$FILTER/g" $LINT_DIFF_DIR/lint-diff.xsl > $TARGET_DIR/$TARGET_FILE.xsl

$LINT_DIR/lint-nt.exe -i$LINT_DIR_WIN env-xml.lnt $* > $TARGET

# append one line after the first line (a\)
sed -i "1a\<?xml-stylesheet type=\"text\/xsl\" href=\"$TARGET_FILE.xsl\"?>" $TARGET
