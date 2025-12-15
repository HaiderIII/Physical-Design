#!/bin/bash
# Wrapper script to open OpenROAD GUI with error suppression

if [ -z "$1" ]; then
    echo "Usage: ./open_gui.sh <path_to_odb_file>"
    exit 1
fi

# Suppress the logger error and open GUI
openroad -gui "$1" 2>&1 | grep -v "invalid format string" | grep -v "LOG ERROR"
