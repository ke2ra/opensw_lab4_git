.PHONY: clean

# 프로젝트 디렉토리 매크로 정의
PROJ_DIR = $(shell pwd)
SRC_DIR = $(PROJ_DIR)/src
INC_DIR = $(PROJ_DIR)/include
OBJ_DIR = $(PROJ_DIR)/obj
BIN_DIR = $(PROJ_DIR)/bin

# 컴파일러 및 플래그 정의
CC = gcc
CFLAGS = -I$(INC_DIR)

# 모든 소스 파일과 오브젝트 파일 목록 정의
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC_FILES))

# 패턴 규칙: .c 파일을 대응하는 .o 파일로 컴파일
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# 실행 파일 생성
$(BIN_DIR)/myapp: $(OBJ_FILES)
	@mkdir -p $(BIN_DIR)
	$(CC) -o $(BIN_DIR)/myapp $^

# 의존성 파일 생성 규칙
DEPS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.d, $(SRC_FILES))

$(OBJ_DIR)/%.d: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	@$(CC) $(CFLAGS) -MM $< > $@
	@sed -i 's|$(notdir $*)\.o:|$(OBJ_DIR)/$*.o $(OBJ_DIR)/$*.d:|' $@

-include $(DEPS)

# clean 명령
clean:
	rm -f $(BIN_DIR)/myapp $(OBJ_DIR)/*.o $(OBJ_DIR)/*.d
