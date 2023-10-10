# Makefile

.PHONY: all clean

# 目标文件和可执行文件名称
TARGET = compute_expr

# 默认编译规则
all: $(TARGET)

# 执行 yacc 命令和编译
$(TARGET): y.tab.c
	gcc $^ -o $@

# 生成 yacc 输出的 C 文件
y.tab.c: expr.y
	yacc $<

# 删除生成的文件
clean:
	rm -f $(TARGET) y.tab.c y.tab.h