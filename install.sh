#!/bin/bash

set -e

PROGRAMS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 打印函数
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "mac"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# 主函数
main() {
    local os_type=$(detect_os)
    
    if [[ "$os_type" == "unknown" ]]; then
        error "不支持的操作系统。仅支持 Arch Linux 和 macOS"
        exit 1
    fi
    
    info "检测到操作系统: $os_type"
    
    # 确定安装脚本名称
    local install_script="install_${os_type}.sh"
    
    # macOS 特殊检查
    if [[ "$os_type" == "mac" ]]; then
        info "macOS 模式: 扫描所有 install_mac.sh 脚本"
        
        # 检查 brew 是否安装
        if ! command -v brew &> /dev/null; then
            error "未检测到 Homebrew，请先安装: https://brew.sh"
            exit 1
        fi
    else
        info "Arch Linux 模式: 扫描所有 install_arch.sh 脚本"
    fi
    
    info "开始全量安装..."
    
    local total=0
    local installed=0
    local failed=0
    
    # 查找所有符合条件的安装脚本
    # 遍历所有分类目录（一级子目录）
    for category_dir in "$PROGRAMS_DIR"/*/; do
        [[ ! -d "$category_dir" ]] && continue
        
        local category=$(basename "$category_dir")
        
        # 遍历该分类下的所有程序目录
        for prog_dir in "$category_dir"*/; do
            [[ ! -d "$prog_dir" ]] && continue
            
            local prog_name=$(basename "$prog_dir")
            local prog_id="${category}/${prog_name}"
            local script_path="${prog_dir}${install_script}"
            
            # 检查是否存在对应系统的安装脚本
            if [[ ! -f "$script_path" ]]; then
                continue
            fi
            
            total=$((total + 1))
            
            echo -e "\n${CYAN}>>> [$total] 安装 $prog_id${NC}"
            
            if bash "$script_path"; then
                success "$prog_id"
                installed=$((installed + 1))
            else
                error "$prog_id 安装失败"
                failed=$((failed + 1))
            fi
        done
    done
    
    # 显示安装结果
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "操作系统: ${YELLOW}$os_type${NC}"
    echo -e "扫描脚本: ${YELLOW}$install_script${NC}"
    echo -e "总计: $total 个程序"
    echo -e "${GREEN}成功: $installed${NC}"
    echo -e "${RED}失败: $failed${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    [[ $failed -gt 0 ]] && exit 1 || exit 0
}

main "$@"
