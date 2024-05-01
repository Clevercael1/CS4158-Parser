flex project.l
bison -d -g ./project.y
gcc -c lex.yy.c project.tab.c
gcc -o executable lex.yy.o project.tab.o
./executable.exe ./text.BUCOL

# flex project.l
# bison -d -g ./project.y
# gcc -c -g lex.yy.c project.tab.c
# gcc -o -g executable lex.yy.o project.tab.o -lfl
# gdb -ex run --args ./executable.exe ./text.BUCOL