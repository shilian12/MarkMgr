#
# Final cross-platform Makefile
# Supports:
# - Windows / Linux / macOS
# - Single-file and multi-file projects
# - Build folder for objects and executable
# - Optional debug mode
# - Safe clean compatible with PowerShell and CMD
#

# Compiler
CC = gcc

# Compile-time flags
CFLAGS := -Wall -Wextra $(if $(DEBUG),-g)

# Library flags
LFLAGS =

# Directories
SRC     := src
INCLUDE := include
LIB     := lib
BUILD   := build

# Platform-specific settings
ifeq ($(OS),Windows_NT)
    MAIN := main.exe
    EXEC := $(BUILD)\$(MAIN)
else
    MAIN := main
    EXEC := ./$(BUILD)/$(MAIN)
endif

# Include directories
INCLUDES := $(patsubst %,-I%, $(INCLUDE))

# Library directories
LIBS := $(patsubst %,-L%, $(LIB))

# Source and object files
SOURCES := $(wildcard $(SRC)/*.c)
OBJECTS := $(patsubst $(SRC)/%.c,$(BUILD)/%.o,$(SOURCES))
DEPS    := $(OBJECTS:.o=.d)

# Default target
all: $(BUILD) $(EXEC)
	@echo "Build complete!"

# Create build folder
$(BUILD):
ifeq ($(OS),Windows_NT)
	if not exist $(BUILD) mkdir $(BUILD)
else
	mkdir -p $(BUILD)
endif

# Compile .c to .o and generate dependency .d files
$(BUILD)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -MMD $< -o $@

# Link executable
$(EXEC): $(OBJECTS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(OBJECTS) $(LFLAGS) $(LIBS)

# Include dependencies
-include $(DEPS)

# Clean (safe for Windows CMD / PowerShell and Linux/macOS)
.PHONY: clean
clean:
ifeq ($(OS),Windows_NT)
	@echo "Cleaning build folder on Windows..."
	@powershell -Command "if (Test-Path '$(EXEC)') { Remove-Item -Force '$(EXEC)' } ; if (Test-Path '$(BUILD)') { Get-ChildItem '$(BUILD)' -Include *.o,*.d -Recurse | Remove-Item -Force }"
else
	@echo "Cleaning build folder on Unix..."
	@rm -f $(EXEC)
	@rm -f $(OBJECTS)
	@rm -f $(DEPS)
endif
	@echo "Cleanup complete!"

# Run the program
.PHONY: run
run: all
ifeq ($(OS),Windows_NT)
	@$(EXEC)
else
	@$(EXEC)
endif
	@echo "Execution complete!"
