
flex project.l
bison -d -g ./project.y
gcc -c lex.yy.c project.tab.c
gcc -o executable lex.yy.o project.tab.o


# gcc -c -g lex.yy.c project.tab.c
# gcc -o -g executable lex.yy.o project.tab.o -lfl

echo "Executing program..."
# gdb -ex run --args ./executable.exe ./text.BUCOL
./executable.exe ./text.BUCOL

echo "Script completed successfully!"
