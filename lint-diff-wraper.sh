#!/bin/bash
#Usage: lint-diff-wraper.sh --target target-name -- [lint options] file

# source使得envsetup.sh里面的变量对当前shell生效，如果是导出的，还会对子shell生效
source /d/PC-Lint9/lint-diff/envsetup.sh

# 取最后一个参数
SRC_FILE=${!#}
SRC_FILE_FULL=`get_fullpath $SRC_FILE`

# 字符串替换，把$NEW_WORK_DIR替换为$OLD_WORK_DIR，里面的/不会引起语法解析错误
BASE_FILE=${SRC_FILE_FULL/$NEW_WORK_DIR/$OLD_WORK_DIR}



$LINT_DIFF_DIR/lint-diff.sh --baseline $BASE_FILE $*
