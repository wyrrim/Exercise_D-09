CC := gcc
CFLAGS := -Wall

LIB := lib
SRC := src
TST := test
BLD := build

TEST_EXE_1 := stack_test

TESTS := $(notdir $(basename $(wildcard $(TST)/*.c)))
INC := $(addprefix -I,$(shell find . -type f -name '*.h' -printf '%h\n' | uniq))

OBJ := $(addprefix $(BLD)/,$(addsuffix .o, $(TESTS)))

aall: .mkbuild $(OBJ)

$(OBJ): $(BLD)/%.o : test/%.c
	$(CC) -MMD $(CFLAGS) -o $@ $(INC) -c $<


#TEST_OBJS_1 := $(notdir $(wildcard $(LIB_DIR)/*/*.c) $(wildcard $(TEST_DIR)/*.c))
#TEST_OBJS_1 := $(addprefix $(BUILD_DIR)/,$(TEST_OBJS_1:.c=.o))

#TEST_OBJS_2 := $(notdir $(wildcard $(LIB_DIR)/*/*.c) $(wildcard $(TEST_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c))
#TEST_OBJS_2 := $(addprefix $(BUILD_DIR)/,$(TEST_OBJS_2:.c=.o))

#PROG_OBJS := $(notdir $(wildcard $(LIB_DIR)/stack/*.c) $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c))
#PROG_OBJS := $(addprefix $(BUILD_DIR)/,$(PROG_OBJS:.c=.o))

lst:
	@echo $(INC)
	@echo $(TESTS)
	@echo $(OBJ)
#	$(foreach test, $(TESTS), test := $(addprefix $(BLD)/,$($(notdir $(wildcard $(LIB)/*/*.c) $(wildcard $(TST)/*.c)):.c=.o)))
#	$(foreach t, $(TESTS), $(t)_c := $(wildcard $(LIB)/*/*.c))
#	$(foreach test, $(TESTS), echo $($(test)_c))



all: .mkbuild $(PROG_EXE) $(TEST_EXE)
	@echo "************ The Targets ************"
	@echo "** clean: to clean"
	@echo "** check_stack: to run the stack test"
	@echo "** check_expr: to run the expression test"
	@echo "** run STR="string_with_parentheses": to run the program"
	@echo "*************************************"

$(PROG_EXE): $(PROG_OBJS)
	$(CC) $^ -lm -o $(BUILD_DIR)/$@

$(TEST_EXE_1): $(TEST_OBJS_1)
	$(CC) $^ -lm -o $(BUILD_DIR)/$@

$(TEST_EXE_2): $(TEST_OBJS_2)
	$(CC) $^ -lm -o $(BUILD_DIR)/$@

#             #
# not working #
#             #
LIB_SRC := $(LIB_DIR)/*
$(BUILD_DIR)/%.o:  $(LIB_SRC)/%.c # stack, unity
	$(CC) -MMD $(CFLAGS) -o $@ -c $<

$(BUILD_DIR)/%.o : $(TEST_DIR)/%.c # expression_test, stack_test
	$(CC) -MMD $(CFLAGS) -o $@ $(INCLUDES) -c $<

#$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c # main
#	$(CC) -MMD $(CFLAGS) -o $@ $(INCLUDES) -c $<

SRS_SRC := $(dir $(wildcard $(SRC_DIR)/*/)) # expression main
#$(BUILD_DIR)/%.o : $(SRS_SRC)%.c
#vpath %.c $(dir $(wildcard $(SRC_DIR)/*/))
$(BUILD_DIR)/%.o : $(SRS_SRC)%.c
	$(CC) -MMD $(CFLAGS) -o $@ $(INCLUDES) -c $<

lst2:
	@echo $(LIB_SRC)
	@echo $(SRS_SRC)
	@echo $(INCLUDES)

run: .mkbuild $(PROG_EXE)
	@echo ""
	@echo "**************************************"
	@echo "********* Run The Program ************"
	@echo "**************************************"
	@echo ""
	@./$(BUILD_DIR)/$(PROG_EXE) $(STR)

check_stack: .mkbuild $(TEST_DIR)
	@echo ""
	@echo "**************************************"
	@echo "******* Run The Stack Test ***********"
	@echo "**************************************"
	@echo ""
	@./$(BUILD_DIR)/$(TEST_EXE_1)

check_expr: .mkbuild $(TEST_DIR)
	@echo ""
	@echo "**************************************"
	@echo "**** Run The Expression Test *********"
	@echo "**************************************"
	@echo ""
	@./$(BUILD_DIR)/$(TEST_EXE_2)

# Include automatically generated dependencies
-include $(OBJECTS:.o=.d)

.PHONY: clean .mkbuild check all lst lst2

clean:
	@rm -rf $(BLD)

.mkbuild:
	@mkdir -p $(BLD)
