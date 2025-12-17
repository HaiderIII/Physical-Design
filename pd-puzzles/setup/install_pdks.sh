#!/bin/bash
#===============================================================================
# PD-Puzzles PDK Installation Script
#===============================================================================
# This script installs the three pedagogical PDKs used in PD-Puzzles:
#   - Nangate45 (beginner puzzles)
#   - Sky130 (intermediate puzzles)
#   - ASAP7 (advanced puzzles)
#
# Usage: ./install_pdks.sh [--nangate45] [--sky130] [--asap7] [--all]
#        ./install_pdks.sh --help
#===============================================================================

set -e

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOJO_ROOT="$(dirname "$SCRIPT_DIR")"
PDK_DIR="$DOJO_ROOT/common/pdks"
CACHE_DIR="$HOME/.pd-puzzles/cache"

# Git repositories
ORFS_REPO="https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git"
ORFS_BRANCH="master"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------
print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  🥋 ${BLUE}PD-Puzzles PDK Installer${NC}                                   ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Install PDKs for PD-Puzzles.

Options:
    --nangate45     Install Nangate45 PDK only (beginner puzzles)
    --sky130        Install Sky130 PDK only (intermediate puzzles)
    --asap7         Install ASAP7 PDK only (advanced puzzles)
    --all           Install all PDKs (default if no option specified)
    --clean         Remove cached downloads before installing
    --help          Show this help message

Examples:
    $(basename "$0")              # Install all PDKs
    $(basename "$0") --nangate45  # Install only Nangate45
    $(basename "$0") --clean      # Clean cache and reinstall all

EOF
}

#-------------------------------------------------------------------------------
# Prerequisite Checks
#-------------------------------------------------------------------------------
check_openroad() {
    print_step "Checking OpenROAD installation..."

    if command -v openroad &> /dev/null; then
        OPENROAD_VERSION=$(openroad -version 2>&1 | head -1 || echo "unknown")
        print_success "OpenROAD found: $OPENROAD_VERSION"
        return 0
    else
        print_error "OpenROAD not found in PATH"
        echo ""
        echo "Please install OpenROAD first. Options:"
        echo "  1. From package: https://github.com/The-OpenROAD-Project/OpenROAD/releases"
        echo "  2. Build from source: https://github.com/The-OpenROAD-Project/OpenROAD"
        echo "  3. Docker: docker pull openroad/flow-ubuntu22.04-builder"
        echo ""
        return 1
    fi
}

check_dependencies() {
    print_step "Checking dependencies..."

    local missing=()

    for cmd in git wget; do
        if ! command -v $cmd &> /dev/null; then
            missing+=($cmd)
        fi
    done

    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing[*]}"
        echo "Please install them with: sudo apt install ${missing[*]}"
        return 1
    fi

    print_success "All dependencies found"
    return 0
}

#-------------------------------------------------------------------------------
# PDK Installation Functions
#-------------------------------------------------------------------------------
setup_directories() {
    print_step "Setting up directories..."

    mkdir -p "$PDK_DIR"
    mkdir -p "$CACHE_DIR"

    print_success "Directories created"
}

clone_orfs_if_needed() {
    local orfs_cache="$CACHE_DIR/OpenROAD-flow-scripts"

    if [ -d "$orfs_cache/.git" ]; then
        print_info "Using cached OpenROAD-flow-scripts" >&2
        print_step "Updating cache..." >&2
        (cd "$orfs_cache" && git fetch origin && git checkout $ORFS_BRANCH && git pull origin $ORFS_BRANCH) >&2 || {
            print_warning "Update failed, using existing cache" >&2
        }
    else
        print_step "Cloning OpenROAD-flow-scripts (this may take a while)..." >&2
        rm -rf "$orfs_cache"
        git clone --depth 1 --branch $ORFS_BRANCH "$ORFS_REPO" "$orfs_cache" >&2
    fi

    echo "$orfs_cache"
}

install_nangate45() {
    print_step "Installing Nangate45 PDK..."

    local orfs_cache=$(clone_orfs_if_needed)
    local src_dir="$orfs_cache/flow/platforms/nangate45"
    local dest_dir="$PDK_DIR/nangate45"

    if [ ! -d "$src_dir" ]; then
        print_error "Nangate45 not found in OpenROAD-flow-scripts"
        return 1
    fi

    # Remove existing installation
    rm -rf "$dest_dir"

    # Copy PDK files
    cp -r "$src_dir" "$dest_dir"

    # Create info file
    cat > "$dest_dir/PDK_INFO.md" << EOF
# Nangate45 PDK

**Source**: OpenROAD-flow-scripts
**Technology**: 45nm FreePDK
**Usage in PD-Puzzles**: Beginner puzzles (Level: Green)

## Key Files
- \`lef/NangateOpenCellLibrary.lef\` - Library LEF
- \`lib/NangateOpenCellLibrary_typical.lib\` - Liberty timing (typical)
- \`gds/NangateOpenCellLibrary.gds\` - GDS layout

## Characteristics
- Well-documented open PDK
- Good for learning fundamentals
- Simplified DRC rules
EOF

    print_success "Nangate45 installed to $dest_dir"
}

install_sky130() {
    print_step "Installing Sky130 PDK..."

    local orfs_cache=$(clone_orfs_if_needed)
    local src_dir="$orfs_cache/flow/platforms/sky130hd"
    local dest_dir="$PDK_DIR/sky130hd"

    if [ ! -d "$src_dir" ]; then
        print_error "Sky130 not found in OpenROAD-flow-scripts"
        return 1
    fi

    # Remove existing installation
    rm -rf "$dest_dir"

    # Copy PDK files
    cp -r "$src_dir" "$dest_dir"

    # Create info file
    cat > "$dest_dir/PDK_INFO.md" << EOF
# Sky130 HD PDK

**Source**: SkyWater / Google + OpenROAD-flow-scripts
**Technology**: 130nm SkyWater
**Usage in PD-Puzzles**: Intermediate puzzles (Level: Yellow)

## Key Files
- \`lef/sky130_fd_sc_hd.tlef\` - Tech LEF
- \`lef/sky130_fd_sc_hd_merged.lef\` - Merged library LEF
- \`lib/sky130_fd_sc_hd__tt_025C_1v80.lib\` - Liberty timing (typical)

## Characteristics
- Real manufacturable PDK (Google/SkyWater MPW)
- More complex DRC rules
- Multiple standard cell variants (HD, HS, MS, etc.)
EOF

    print_success "Sky130 installed to $dest_dir"
}

install_asap7() {
    print_step "Installing ASAP7 PDK..."

    local orfs_cache=$(clone_orfs_if_needed)
    local src_dir="$orfs_cache/flow/platforms/asap7"
    local dest_dir="$PDK_DIR/asap7"

    if [ ! -d "$src_dir" ]; then
        print_error "ASAP7 not found in OpenROAD-flow-scripts"
        return 1
    fi

    # Remove existing installation
    rm -rf "$dest_dir"

    # Copy PDK files
    cp -r "$src_dir" "$dest_dir"

    # Create info file
    cat > "$dest_dir/PDK_INFO.md" << EOF
# ASAP7 PDK

**Source**: Arizona State University + OpenROAD-flow-scripts
**Technology**: 7nm predictive PDK
**Usage in PD-Puzzles**: Advanced puzzles (Level: Red)

## Key Files
- \`lef/asap7_tech_1x_201209.lef\` - Tech LEF
- \`lef/asap7sc7p5t_*.lef\` - Library LEF files
- \`lib/asap7sc7p5t_*.lib\` - Liberty timing files

## Characteristics
- Predictive 7nm FinFET technology
- Complex multi-patterning rules
- Realistic advanced node challenges
- Great for learning cutting-edge concepts
EOF

    print_success "ASAP7 installed to $dest_dir"
}

#-------------------------------------------------------------------------------
# Summary and Verification
#-------------------------------------------------------------------------------
print_summary() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  📋 ${BLUE}Installation Summary${NC}                                       ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local installed=0
    local total=3

    # Check Nangate45
    if [ -d "$PDK_DIR/nangate45" ]; then
        print_success "Nangate45  │ Installed │ Beginner puzzles"
        ((installed++))
    else
        print_warning "Nangate45  │ Not installed"
    fi

    # Check Sky130
    if [ -d "$PDK_DIR/sky130hd" ]; then
        print_success "Sky130 HD  │ Installed │ Intermediate puzzles"
        ((installed++))
    else
        print_warning "Sky130 HD  │ Not installed"
    fi

    # Check ASAP7
    if [ -d "$PDK_DIR/asap7" ]; then
        print_success "ASAP7      │ Installed │ Advanced puzzles"
        ((installed++))
    else
        print_warning "ASAP7      │ Not installed"
    fi

    echo ""
    echo -e "PDK directory: ${BLUE}$PDK_DIR${NC}"
    echo ""

    if [ $installed -eq $total ]; then
        print_success "All PDKs installed successfully!"
    elif [ $installed -gt 0 ]; then
        print_info "$installed/$total PDKs installed"
    else
        print_error "No PDKs installed"
    fi

    echo ""
    echo "Next steps:"
    echo "  1. Verify installation: openroad $SCRIPT_DIR/verify_install.tcl"
    echo "  2. Start with puzzles:  cd $DOJO_ROOT/puzzles/01_synthesis"
    echo ""
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------
main() {
    print_header

    # Parse arguments
    local install_nangate45=false
    local install_sky130=false
    local install_asap7=false
    local clean_cache=false
    local any_selected=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --nangate45)
                install_nangate45=true
                any_selected=true
                shift
                ;;
            --sky130)
                install_sky130=true
                any_selected=true
                shift
                ;;
            --asap7)
                install_asap7=true
                any_selected=true
                shift
                ;;
            --all)
                install_nangate45=true
                install_sky130=true
                install_asap7=true
                any_selected=true
                shift
                ;;
            --clean)
                clean_cache=true
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # If no PDK selected, install all
    if [ "$any_selected" = false ]; then
        install_nangate45=true
        install_sky130=true
        install_asap7=true
    fi

    # Clean cache if requested
    if [ "$clean_cache" = true ]; then
        print_step "Cleaning cache..."
        rm -rf "$CACHE_DIR"
        print_success "Cache cleaned"
    fi

    # Check prerequisites
    check_openroad || exit 1
    check_dependencies || exit 1

    # Setup directories
    setup_directories

    # Install selected PDKs
    if [ "$install_nangate45" = true ]; then
        install_nangate45 || print_warning "Nangate45 installation failed"
    fi

    if [ "$install_sky130" = true ]; then
        install_sky130 || print_warning "Sky130 installation failed"
    fi

    if [ "$install_asap7" = true ]; then
        install_asap7 || print_warning "ASAP7 installation failed"
    fi

    # Print summary
    print_summary
}

main "$@"
