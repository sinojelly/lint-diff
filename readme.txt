
This tool diffs the old and new files, only show warnings on the lines have difference. 
It does not impact the lint result, just filter the warnings by lint-diff.xsl.


You can use this lint-diff tool these ways:
1. show warnings relative to a workspace of old code.
a) modify variables in envsetup.sh
b) run lint-diff-wraper.sh
eg: lint-diff-wraper.sh --target out/file-name.xml -- -e830 file-name.c

2. show warnings relative to the specified git commit
a) use lint-diff.sh, you shold take a look at it first.
eg: lint-diff.sh --baseline fbe93eadb61b27cc77bc67cb9a3f66c7c6a7930d --target out/file-name.xml -- -e830 file-name.c
