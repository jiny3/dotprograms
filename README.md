# dotprograms

跨平台程序安装管理系统 (支持 Arch Linux 和 macOS)

## 项目结构

```
/home/x/dotprograms/
├── install.sh          # 全量安装脚本
├── system/            # 系统基础工具 (4) - 混合平台
│   ├── paru/          # Arch: AUR助手
│   ├── fcitx5/        # Arch: 中文输入法
│   ├── font/          # 跨平台: 字体
│   └── brew/          # Mac: 包管理器
├── terminal/          # 终端环境工具 (14) - 跨平台核心
│   ├── zsh/
│   ├── starship/
│   ├── neovim/
│   ├── ghostty/
│   ├── tmux/
│   ├── better-cli/
│   └── ...
├── desktop/           # 桌面环境组件 (6) - Arch Linux 专属
│   ├── niri/
│   ├── noctalia/
│   ├── flatpak/
│   ├── ly/            # TUI登录管理器
│   └── ...
└── apps/              # GUI 应用程序 (11) - Arch Linux 专属
    ├── discord/
    ├── wechat/
    ├── steam/
    └── ...
```

每个程序目录包含：
- `description` - 程序描述
- `install_arch.sh` - Arch Linux 安装脚本
- `install_mac.sh` - macOS 安装脚本 (system/terminal 部分程序)
- `uninstall_arch.sh` - Arch Linux 卸载脚本
- `uninstall_mac.sh` - macOS 卸载脚本 (system/terminal 部分程序)

## 使用方法

### 全量安装 (推荐)

脚本会**自动检测操作系统**并执行相应安装：

```bash
./install.sh
```

**Arch Linux 行为:**
- 安装所有分类的程序 (system, terminal, desktop, apps)
- 使用 `paru` 作为包管理器

**macOS 行为:**
- 安装 system/ 和 terminal/ 分类中支持 macOS 的程序
- 使用 `brew` 作为包管理器
- 需要先安装 Homebrew: https://brew.sh

### 手动安装单个程序
```bash
cd system/paru
./install_arch.sh
```

### 卸载程序
```bash
cd system/paru
./uninstall_arch.sh
```

## 程序列表

### system (4个) - 系统基础工具
- **paru** - AUR 助手工具 (Arch)
- **fcitx5** - 中文输入法 (Arch)
- **font** - 字体 (跨平台)
- **brew** - macOS包管理器 (Mac)

### terminal (14个) - 终端环境
- **zsh** - Z Shell
- **starship** - Shell提示符
- **zimfw** - Zsh插件管理器
- **ghostty** - GPU加速终端
- **tmux** - 终端复用器
- **neovim** - 编辑器
- **opencode** - AI代码编辑器
- **yazi** - 文件管理器
- **lazygit** - Git UI
- **better-cli** - 现代CLI工具集 (bat/eza/fd/fzf/zoxide/ripgrep/ffmpeg/7zip/jq/poppler/resvg/imagemagick)
- **fastfetch** - 系统信息
- **mihomo** - 代理工具
- **trash-cli** - 回收站
- **podman** - 容器引擎

### desktop (6个) - 桌面环境
- **niri** - 平铺Wayland合成器
- **noctalia** - 桌面Shell
- **xdg** - 桌面门户
- **flatpak** - Flatpak包管理器
- **flatseal** - Flatpak权限管理器
- **ly** - TUI登录管理器

### apps (11个) - GUI应用
- **discord** - 即时通讯
- **feishu** - 飞书办公
- **qq** - QQ
- **telegram** - Telegram
- **wechat** - 微信
- **wemeet** - 腾讯会议
- **steam** - Steam游戏平台
- **heroic** - Epic/GOG游戏启动器
- **vlc** - 媒体播放器
- **zen** - Zen浏览器
- **zotero** - 文献管理

## 平台支持

| 分类     | Arch Linux | macOS        |
|----------|------------|--------------|
| system   | ✅ (3个)   | ✅ (2个)     |
| terminal | ✅ (14个)  | ✅ (11个)    |
| desktop  | ✅ (6个)   | ❌           |
| apps     | ✅ (11个)  | ❌           |

**macOS 支持的程序 (13个):**
- 系统: brew (包管理), font (字体)
- Shell: zsh, starship, zimfw
- 终端: ghostty, tmux
- 编辑器: neovim, opencode
- 工具: yazi, lazygit, better-cli, fastfetch

## 添加新程序

### Arch Linux 程序

1. 在对应类别目录下创建程序文件夹
2. 添加 `description` 文件（简短描述）
3. 添加 `install_arch.sh` 脚本
4. 添加 `uninstall_arch.sh` 脚本

示例：
```bash
mkdir -p terminal/mynewapp
echo "我的新应用" > terminal/mynewapp/description
echo '#!/bin/bash' > terminal/mynewapp/install_arch.sh
echo 'paru -S --noconfirm --needed mynewapp' >> terminal/mynewapp/install_arch.sh
chmod +x terminal/mynewapp/install_arch.sh
```

### macOS 程序 (Terminal 分类)

1. 在 terminal 目录下创建程序文件夹
2. 添加 `description` 文件
3. 添加 `install_mac.sh` 脚本

示例：
```bash
mkdir -p terminal/mynewapp
echo "我的新应用" > terminal/mynewapp/description
echo '#!/bin/bash' > terminal/mynewapp/install_mac.sh
echo 'brew install mynewapp' >> terminal/mynewapp/install_mac.sh
chmod +x terminal/mynewapp/install_mac.sh
```

## 分类说明

- **system**: 系统基础工具，混合平台支持（Arch专属、Mac专属、跨平台）
- **terminal**: 命令行/终端环境相关工具，跨平台核心，大部分支持 macOS
- **desktop**: Wayland/图形桌面环境组件，Arch Linux 桌面必需
- **apps**: 用户级 GUI 应用程序，按需安装
