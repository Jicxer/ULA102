# Variables
SCRIPT = compile.sh   # Your grading script
LOG_DIR = logs
OUTPUT_DIR = compiled_outputs
SUBMISSIONS_DIR = submissions/assigned_students

run:
	@echo "Running grading script..."
	./$(SCRIPT)

clean:
	@echo "Cleaning up logs and compiled outputs..."
	rm -rf $(LOG_DIR)/*
	rm -rf $(OUTPUT_DIR)/*

clean-all: clean
	@echo "Cleaning assigned student submissions..."
	rm -rf $(SUBMISSIONS_DIR)/*

help:
	@echo "Available commands:"
	@echo "  make run         - Run the grading script"
	@echo "  make clean       - Remove all logs and compiled outputs"
	@echo "  make clean-all   - Remove logs, compiled outputs, and assigned student submissions"
	@echo "  make help        - Display this help message"

.PHONY: run clean clean-all setup help
