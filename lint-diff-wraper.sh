#!/bin/bash
#Usage: lint-diff-wraper.sh --target target-name -- [lint options] file

# sourceʹ��envsetup.sh����ı����Ե�ǰshell��Ч������ǵ����ģ��������shell��Ч
source /d/PC-Lint9/lint-diff/envsetup.sh

# ȡ���һ������
SRC_FILE=${!#}
SRC_FILE_FULL=`get_fullpath $SRC_FILE`

# �ַ����滻����$NEW_WORK_DIR�滻Ϊ$OLD_WORK_DIR�������/���������﷨��������
BASE_FILE=${SRC_FILE_FULL/$NEW_WORK_DIR/$OLD_WORK_DIR}



$LINT_DIFF_DIR/lint-diff.sh --baseline $BASE_FILE $*
