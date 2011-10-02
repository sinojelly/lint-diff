#!/bin/bash
#Usage: lint-diff-wraper.sh --target target-name -- [lint options] file

source /d/PC-Lint9/lint-diff/envsetup.sh

SRC_FILE=${!#}
SRC_FILE_FULL=`get_fullpath $SRC_FILE`

BASE_FILE=${SRC_FILE_FULL/$NEW_WORK_DIR/$OLD_WORK_DIR}


$LINT_DIFF_DIR/lint-diff.sh --baseline $BASE_FILE $*
