#include <stdlib.h>
#include <string.h>

struct yType{
    char* s;
    double d;
};

// 键值对结构体
struct KeyValuePair {
    char* key;
    double value;
};

// 符号表结构体
struct SymbolTable {
    struct KeyValuePair* pairs; // 键值对数组
    int size; // 符号表大小
    int capacity; // 符号表容量
};

// 初始化符号表
void initSymbolTable(struct SymbolTable* table, int capacity) {
    table->pairs = (struct KeyValuePair*)malloc(sizeof(struct KeyValuePair) * capacity);
    table->size = 0;
    table->capacity = capacity;
}

// 销毁符号表
void destroySymbolTable(struct SymbolTable* table) {
    for (int i = 0; i < table->size; i++) {
        free(table->pairs[i].key);
    }
    free(table->pairs);
}

// 查询符号表
double lookupSymbol(struct SymbolTable* table, const char* key) {
    for (int i = 0; i < table->size; i++) {
        if (strcmp(table->pairs[i].key, key) == 0) {
            return table->pairs[i].value;
        }
    }
    return 0; // 没有找到键值对
}

// 添加或更新符号表
void insertSymbol(struct SymbolTable* table, const char* key, double value) {
    // 查找已有的键值对
    for (int i = 0; i < table->size; i++) {
        if (strcmp(table->pairs[i].key, key) == 0) {
            table->pairs[i].value = value;
            return;
        }
    }

    // 如果符号表已满，需要重新分配内存
    if (table->size == table->capacity) {
        table->capacity *= 2;
        table->pairs = (struct KeyValuePair*)realloc(table->pairs, sizeof(struct KeyValuePair) * table->capacity);
    }

    // 添加新的键值对
    table->pairs[table->size].key = (char*)malloc(strlen(key) + 1);
    strcpy(table->pairs[table->size].key, key);
    table->pairs[table->size].value = value;
    table->size++;
}