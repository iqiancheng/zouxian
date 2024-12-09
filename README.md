# Zouxian 配置文件文档

## 1. 简介

本文档提供了关于 Zouxian 配置文件的详细信息。该配置文件旨在为中国版 Mac 型号启用 Apple Intelligence 和 Xcode LLM 功能。Zouxian 提供两种安装方式：直接使用安装脚本或通过配置文件进行安装。

## 2. 安装说明

### 2.1 一键安装（推荐方式）

使用以下命令一键安装：

```bash
sudo curl -fsSL https://raw.githubusercontent.com/iqiancheng/zouxian/HEAD/install_remote.sh | bash
```

如果遇到权限问题，请确保使用 sudo 运行命令。

基于macOS系统15.1及以上版本，如果低于15.1版本，请通过App Store升级系统或通过 [Direct installer InstallAssistant.pkg](https://www.iclarified.com/94896/where-to-download-macos-sequoia) 升级系统。

### 2.2 使用配置文件安装（备选方式）

如果由于某些原因无法直接执行安装脚本，可以使用配置文件方式安装：

1. **准备配置文件**：
   - 下载 `zouxian.mobileconfig` 文件

2. **安装配置文件**：
   - 双击 `zouxian.mobileconfig` 文件
   - 按照系统提示完成安装
   - 系统会自动执行必要的安装步骤

## 3. 重要注意事项

使用 Zouxian 时，请注意以下几点：

1. **系统完整性保护（SIP）**：在安装之前，必须在恢复模式下手动禁用 SIP。

2. **管理员权限**：无论使用哪种安装方式，都需要 Mac 的管理员权限。

## 4. 故障排除

如果遇到问题：

1. 使用控制台应用检查系统日志是否有任何错误消息。
2. 验证 SIP 是否已正确禁用。
3. 确保所有必需文件都在正确的位置。
4. 如果更改没有生效，请尝试重新启动系统。

## 5. 支持

如需其他支持或报告问题，请访问 Zouxian 项目存储库或直接联系维护人员。

请注意，在执行任何安装步骤之前，请确保您了解其对系统的影响。建议在进行操作前备份重要数据。
