CC_AFL=$(AFL_PATH)afl-clang-fast
ASAN_FLAG= -fsanitize=address
DEBUG_CFLAGS=$(ASAN_FLAG) -g
CFLAGS = -O2
LDFLAGS = -lreadline 
BIN = bin
TARGET = main.c
TARGET_LIB=lib/*.c

all:
	$(CC) -c $(TARGET) $(CFLAGS) -o $(TARGET).o
	$(CC) -c $(TARGET_LIB) $(CFLAGS) -o $(TARGET_LIB).o
	$(CC) $(TARGET_LIB) $(TARGET) $(LDFLAGS) -o $(BIN) 
debug:
	$(CC_AFL) -c $(DEBUG_CFLAGS) $(TARGET)  -o $(TARGET).o -Wall -Wextra 
	$(CC_AFL) -c $(DEBUG_CFLAGS) $(TARGET_LIB) -o $(TARGET_LIB).o -Wall -Wextra 
	$(CC_AFL) $(TARGET).o $(TARGET_LIB).o $(LDFLAGS) $(ASAN_FLAG) -o $(BIN)_asan
clean:
	rm -rf in out
	rm $(BIN)*
	rm *.o

fuzz: debug
	rm -rf in out
	mkdir in out 
	echo 1 >> in/1
	$(AFL_PATH)afl-fuzz -i in -o out -- ./bin_asan


