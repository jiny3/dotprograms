#!/bin/bash
#
# dotprograms 全量安装脚本
# 支持 Arch Linux 和 macOS
# 自动检测系统并按优先级安装所有程序
# 包含 5 个分类: system, terminal, desktop, apps, dev
#

set -euo pipefail

# 全局常量
readonly PROGRAMS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# 打印函数
info() { 
    echo -e "${CYAN}[INFO]${NC} $*" >&2
}

success() { 
    echo -e "${GREEN}[OK]${NC} $*" >&2
}

error() { 
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

warn() { 
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

# 检测操作系统
detect_os() {
    if [[ "${OSTYPE}" == "darwin"* ]]; then
        echo "mac"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# 检查必要的依赖
check_dependencies() {
    local os_type="$1"
    
    if [[ "${os_type}" == "mac" ]]; then
        # macOS 检查 brew（如果未安装会在后续自动安装）
        if ! command -v brew &> /dev/null; then
            warn "Homebrew 未安装，将在第一步自动安装 system/brew"
        fi
    elif [[ "${os_type}" == "arch" ]]; then
        # Arch Linux 检查基础命令
        if ! command -v bash &> /dev/null; then
            error "缺少 bash，无法继续"
            return 1
        fi
    fi
    
    return 0
}

# 安装单个程序
install_program() {
    local prog_id="$1"
    local script_path="$2"
    local counter="$3"
    
    if [[ ! -f "${script_path}" ]]; then
        error "安装脚本不存在: ${script_path}"
        return 1
    fi
    
    if [[ ! -x "${script_path}" ]]; then
        error "安装脚本没有执行权限: ${script_path}"
        return 1
    fi
    
    echo -e "\n${CYAN}>>> [${counter}] 安装 ${prog_id}${NC}"
    
    if bash "${script_path}"; then
        success "${prog_id}"
        return 0
    else
        error "${prog_id} 安装失败"
        return 1
    fi
}

# 收集待安装程序
collect_programs() {
    local install_script="$1"
    local -n priority_ref="$2"  # nameref for priority_programs
    local -n normal_ref="$3"    # nameref for normal_programs
    
    local category category_dir prog_dir prog_name prog_id script_path
    
    # 遍历所有分类目录
    for category_dir in "${PROGRAMS_DIR}"/*/; do
        [[ ! -d "${category_dir}" ]] && continue
        
        category="$(basename "${category_dir}")"
        
        # 遍历分类下的所有程序目录
        for prog_dir in "${category_dir}"*/; do
            [[ ! -d "${prog_dir}" ]] && continue
            
            prog_name="$(basename "${prog_dir}")"
            prog_id="${category}/${prog_name}"
            script_path="${prog_dir}${install_script}"
            
            # 检查安装脚本是否存在
            [[ ! -f "${script_path}" ]] && continue
            
            # 按优先级分类
            # 优先级: paru/brew (最先) -> flatpak (第二) -> 其他
            case "${prog_name}" in
                paru|brew)
                    # 包管理器最优先（头部插入）
                    priority_ref=("${prog_name}|${prog_id}|${script_path}" "${priority_ref[@]}")
                    ;;
                flatpak)
                    # flatpak 次优先（尾部追加）
                    priority_ref+=("flatpak|${prog_id}|${script_path}")
                    ;;
                *)
                    # 普通程序
                    normal_ref+=("${prog_id}|${script_path}")
                    ;;
            esac
        done
    done
}

# 执行安装流程
execute_installation() {
    local -n priority_ref="$1"
    local -n normal_ref="$2"
    local -n counter_ref="$3"
    local -n installed_ref="$4"
    local -n failed_ref="$5"
    
    local prog_info prog_type prog_id script_path
    
    # 第一阶段: 安装优先级程序 (paru/brew -> flatpak)
    for prog_info in "${priority_ref[@]}"; do
        IFS='|' read -r prog_type prog_id script_path <<< "${prog_info}"
        counter_ref=$((counter_ref + 1))
        
        if install_program "${prog_id}" "${script_path}" "${counter_ref}"; then
            installed_ref=$((installed_ref + 1))
        else
            failed_ref=$((failed_ref + 1))
        fi
    done
    
    # 第二阶段: 安装普通程序
    for prog_info in "${normal_ref[@]}"; do
        IFS='|' read -r prog_id script_path <<< "${prog_info}"
        counter_ref=$((counter_ref + 1))
        
        if install_program "${prog_id}" "${script_path}" "${counter_ref}"; then
            installed_ref=$((installed_ref + 1))
        else
            failed_ref=$((failed_ref + 1))
        fi
    done
}

# 显示安装结果摘要
show_summary() {
    local os_type="$1"
    local install_script="$2"
    local total="$3"
    local installed="$4"
    local failed="$5"
    
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "操作系统: ${YELLOW}${os_type}${NC}"
    echo -e "扫描脚本: ${YELLOW}${install_script}${NC}"
    echo -e "总计: ${total} 个程序"
    echo -e "${GREEN}成功: ${installed}${NC}"
    
    if [[ ${failed} -gt 0 ]]; then
        echo -e "${RED}失败: ${failed}${NC}"
    else
        echo -e "失败: ${failed}"
    fi
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 主函数
main() {
    local os_type
    local install_script
    local total=0
    local installed=0
    local failed=0
    local counter=0
    
    declare -a priority_programs=()  # 优先安装列表
    declare -a normal_programs=()    # 普通程序列表
    
    # 检测操作系统
    os_type="$(detect_os)"
    
    if [[ "${os_type}" == "unknown" ]]; then
        error "不支持的操作系统，仅支持 Arch Linux 和 macOS"
        exit 1
    fi
    
    info "检测到操作系统: ${os_type}"
    
    # 检查依赖
    if ! check_dependencies "${os_type}"; then
        exit 1
    fi
    
    # 确定安装脚本名称
    install_script="install_${os_type}.sh"
    
    # 显示运行模式
    if [[ "${os_type}" == "mac" ]]; then
        info "macOS 模式: 扫描所有 install_mac.sh 脚本 (system/terminal/dev 分类)"
    else
        info "Arch Linux 模式: 扫描所有 install_arch.sh 脚本 (全部分类)"
    fi
    
    info "开始全量安装..."
    
    # 收集待安装程序
    collect_programs "${install_script}" priority_programs normal_programs
    
    # 执行安装
    execute_installation priority_programs normal_programs counter installed failed
    
    # 计算总数
    total=${counter}
    
    # 显示结果摘要
    show_summary "${os_type}" "${install_script}" "${total}" "${installed}" "${failed}"
    
    # 返回退出码
    if [[ ${failed} -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# 脚本入口
main "$@"
