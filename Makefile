CC_AFL=$(AFL_PATH)afl-clang
ASAN_FLAG= -fsanitize=address
DEBUG_CFLAGS=$(ASAN_FLAG) -g
COV_FLAG=--coverage
CFLAGS = -O2
LDFLAGS = -lreadline 
BIN = bin
TARGET = main.c
TARGET_LIB=lib/*.c


help:
	@echo "Available targets:"
	@echo "  all             : Build the main application"
	@echo "  debug           : Build the application with AFL and ASAN for debugging"
	@echo "  clean           : Remove object files"
	@echo "  fuzz            : Run AFL fuzzing sessions"
	@echo "  coverage        : Generate code coverage report"
	@echo "  coverage_build  : Build the application with code coverage instrumentation"


all: 
	$(CC) -c $(TARGET) $(CFLAGS) -o $(TARGET).o
	$(CC) -c $(TARGET_LIB) $(CFLAGS) -o $(TARGET_LIB).o
	$(CC) $(TARGET_LIB) $(TARGET) $(LDFLAGS) -o $(BIN) 
	rm *.o
 
debug: 
	$(CC_AFL) -c $(DEBUG_CFLAGS) $(TARGET)  -o $(TARGET).o -Wall -Wextra 
	$(CC_AFL) -c $(DEBUG_CFLAGS) $(TARGET_LIB) -o $(TARGET_LIB).o -Wall -Wextra 
	$(CC_AFL) $(TARGET).o $(TARGET_LIB).o $(LDFLAGS) $(ASAN_FLAG) -o $(BIN)_asan
	rm *.o

fuzz: debug
	rm -rf in out
	mkdir in out
	echo 1 >> in/1
	echo "l" >> in/2
	echo "ф" >> in/3
	tmux new-session -d -s my_session -n Window1 '$(AFL_PATH)afl-fuzz -i in -o out -M master -x utf8.dict -- ./$(BIN)_asan'
	tmux new-window -t my_session:1 -n Window2 '$(AFL_PATH)afl-fuzz -i in -o out -S slave1 -x utf8.dict -- ./$(BIN)_asan'
	tmux new-window -t my_session:2 -n Window3 '$(AFL_PATH)afl-fuzz -i in -o out -S slave2 -x utf8.dict -- ./$(BIN)_asan'
	tmux new-window -t my_session:3 -n Window4 '$(AFL_PATH)afl-fuzz -i in -o out -S slave3 -x utf8.dict -- ./$(BIN)_asan'
	tmux select-window -t my_session:0
	tmux attach-session -t my_session

coverage_build:
	$(CC) -c $(COV_FLAG) $(TARGET)  -o $(TARGET).o -Wall -Wextra 
	$(CC) -c $(COV_FLAG) $(TARGET_LIB) -o $(TARGET_LIB).o -Wall -Wextra 
	$(CC) $(TARGET).o $(TARGET_LIB).o $(LDFLAGS) $(COV_FLAG) -o $(BIN)_cov
	rm *.o

coverage: coverage_build
	./get_cover.sh
	lcov -t "lab4" -o lab4.info -c -d .
	genhtml -o report lab4.info

clean:
	rm -rf in out $(BIN)* *.gcno *.gcda
