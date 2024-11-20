SCRIPT = compile.sh
LOG_DIR = logs
OUTPUT_DIR = compiled_outputs
SUBMISSIONS_DIR = submissions
GRADING_FILE = grading.txt

run:
	@echo "Running grading script..."
	./$(SCRIPT)

clean:
	@echo "Cleaning up logs and compiled outputs..."
	rm -rf $(LOG_DIR)/*
	rm -rf $(OUTPUT_DIR)/*
clean-all: clean
	make clean
	@echo "Cleaning assigned student submissions..."
	rm -rf $(SUBMISSIONS_DIR)/*
	rm $(GRADING_FILE)
setup:
	@echo "Setting up directories..."
	mkdir -p $(LOG_DIR) $(OUTPUT_DIR) $(SUBMISSIONS_DIR)
	touch $(GRADING_FILE)
help:
	@echo "Available commands:"
	@echo "  make run         - Run the grading script"
	@echo "  make clean       - Remove all logs and compiled outputs"
	@echo "  make clean-all   - Remove logs, compiled outputs, and assigned student submissions"
	@echo "  make setup       - Set up directories (logs, compiled_outputs, assigned_students)"
	@echo "  make help        - Display this help message"
.PHONY: run clean clean-all setup help
