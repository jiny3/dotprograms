# dotprograms

跨平台程序安装管理系统 (支持 Arch Linux 和 macOS)

## 项目结构

```
dotprograms/
├── install.sh          # 全量安装脚本
├── system/            # 系统基础工具 (6)
│   ├── paru/          # AUR 助手工具
│   ├── brew/          # macOS 包管理器
│   ├── fcitx5/        # 中文输入法引擎
│   ├── font/          # 系统字体配置
│   ├── cliphist/      # 剪贴板历史管理
│   └── xwayland/      # X11 兼容层
├── terminal/          # 终端环境工具 (15)
│   ├── zsh/
│   ├── starship/
│   ├── neovim/
│   ├── ghostty/
│   ├── tmux/
│   ├── stow/
│   ├── better-cli/
│   └── ...
├── desktop/           # 桌面环境组件 (8) - Arch Linux 专属
│   ├── niri/
│   ├── noctalia/
│   ├── flatpak/
│   ├── ly/
│   ├── mate-polkit/
│   ├── xorg-xrdb/
│   └── ...
├── apps/              # GUI 应用程序 (11) - Arch Linux 专属
│   ├── discord/
│   ├── wechat/
│   ├── steam/
│   └── ...
└── dev/               # 开发工具 (2)
    ├── go/
    └── uv/
```

每个程序目录包含：
- `description` - 程序描述
- `install_arch.sh` - Arch Linux 安装脚本
- `install_mac.sh` - macOS 安装脚本 (部分程序)
- `uninstall_arch.sh` - Arch Linux 卸载脚本
- `uninstall_mac.sh` - macOS 卸载脚本 (部分程序)

## 使用方法

### 全量安装

脚本会自动检测操作系统并执行相应安装：

```bash
./install.sh
```

**Arch Linux** - 安装全部分类，使用 `paru` 作为包管理器

**macOS** - 安装 system/terminal 中支持 macOS 的程序，使用 `brew` 作为包管理器

### 单个安装/卸载

```bash
# 安装
cd terminal/neovim && ./install_arch.sh

# 卸载
cd terminal/neovim && ./uninstall_arch.sh
```

## 程序列表

### system (6个)
- **paru** - AUR 助手工具
- **brew** - macOS 包管理器
- **fcitx5** - 中文输入法引擎
- **font** - 系统字体配置
- **cliphist** - 剪贴板历史管理
- **xwayland** - X11 兼容层

### terminal (15个)
- **zsh** - 命令行 Shell
- **zimfw** - Zsh 插件管理器
- **starship** - 跨 Shell 提示符
- **ghostty** - GPU 加速终端模拟器
- **tmux** - 终端复用器
- **neovim** - 可扩展的终端编辑器
- **opencode** - AI 编程助手
- **yazi** - 终端文件管理器
- **lazygit** - Git 终端 UI
- **stow** - 符号链接管理工具
- **better-cli** - 现代命令行工具集
- **fastfetch** - 系统信息显示工具
- **mihomo** - 多协议代理工具
- **trash-cli** - 命令行回收站
- **podman** - 容器引擎

### desktop (8个)
- **niri** - 滚动平铺 Wayland 合成器
- **noctalia** - 桌面面板和启动器
- **xdg** - 桌面集成门户
- **flatpak** - 沙盒应用包管理器
- **flatseal** - Flatpak 权限管理器
- **ly** - TUI 登录管理器
- **mate-polkit** - 权限认证代理
- **xorg-xrdb** - X11 资源数据库管理

### apps (11个)
- **discord** - 游戏社区沟通平台
- **feishu** - 企业办公协作平台
- **qq** - 即时通讯软件
- **telegram** - 加密即时通讯应用
- **wechat** - 即时通讯工具
- **wemeet** - 视频会议工具
- **steam** - PC 游戏平台
- **heroic** - Epic/GOG 游戏启动器
- **vlc** - 全格式媒体播放器
- **zen** - 隐私优先的浏览器
- **zotero** - 文献管理工具

### dev (2个)
- **go** - Go 语言工具链
- **uv** - Python 环境管理工具

## 平台支持

| 分类 | Arch Linux | macOS |
|------|:----------:|:-----:|
| system | 5 | 2 |
| terminal | 15 | 11 |
| desktop | 8 | -- |
| apps | 11 | -- |
| dev | 2 | 2 |

**macOS 支持的程序 (15个):**
- 系统: brew, font
- 终端: starship, zimfw, ghostty, tmux, neovim, opencode, yazi, lazygit, stow, better-cli, fastfetch
- 开发: go, uv

## 添加新程序

1. 在对应分类目录下创建程序文件夹
2. 添加 `description` 文件
3. 添加 `install_arch.sh` / `install_mac.sh` 脚本
4. 添加 `uninstall_arch.sh` / `uninstall_mac.sh` 脚本

```bash
mkdir -p terminal/mynewapp
echo "简短描述" > terminal/mynewapp/description
echo '#!/bin/bash' > terminal/mynewapp/install_arch.sh
echo 'paru -S --noconfirm --needed mynewapp' >> terminal/mynewapp/install_arch.sh
chmod +x terminal/mynewapp/install_arch.sh
```

## 分类说明

- **system** - 系统基础工具，包管理器、输入法、字体等
- **terminal** - 命令行/终端环境工具，大部分支持跨平台
- **desktop** - Wayland 桌面环境组件，Arch Linux 专属
- **apps** - GUI 应用程序，Arch Linux 专属
- **dev** - 开发工具和编程环境
