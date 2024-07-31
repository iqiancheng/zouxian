# Zouxian 配置文件文档

## 1. 简介

本文档提供了关于 Zouxian 配置文件的详细信息。该配置文件旨在为中国版 Mac 型号启用 Apple Intelligence 和 Xcode LLM 功能。配置文件生成为 .mobileconfig 文件，可以安装在 macOS 设备上，以自动化 Zouxian 工具的设置过程。

## 2. 生成原理

Zouxian 配置文件使用 Python 脚本生成，该脚本创建一个格式正确的 .mobileconfig 文件。以下是生成过程的概述：

1. **文件读取**：脚本读取两个关键文件的内容：
   - `zouxian.sh`：Zouxian 工具的主脚本。
   - `cat.me0w.zouxian.plist`：Zouxian 的启动守护程序配置。

2. **内容编码**：这些文件的内容使用 base64 编码，以确保它们可以安全地嵌入到配置文件中。

3. **配置文件结构创建**：脚本构建一个字典，表示配置文件的结构。这包括：
   - PayloadContent：包含主要配置项。
   - PayloadDisplayName：配置文件的用户友好名称。
   - PayloadIdentifier：配置文件的唯一标识符。
   - PayloadType, PayloadUUID, PayloadVersion：所有配置文件的标准字段。

4. **文件放置配置**：配置文件包含将文件放置在目标系统特定位置的指令：
   - `/usr/local/bin/zouxian`：主 Zouxian 脚本。
   - `/Library/LaunchDaemons/cat.me0w.zouxian.plist`：启动守护程序配置。

5. **版本控制**：脚本生成文件内容的 MD5 哈希值，以启用版本控制和高效更新。

6. **Plist 生成**：最后，脚本使用 `plistlib` 模块将构建的字典转换为格式正确的属性列表（.plist）文件，这是 .mobileconfig 文件的标准格式。

## 3. 使用说明

要使用 Zouxian 配置文件，请按照以下步骤操作：

1. **生成配置文件**：
   - 确保您的系统上安装了 Python 3。
   - 运行生成脚本：`python3 zouxian_config_generator.py`
   - 这将在同一目录中创建一个名为 `zouxian.mobileconfig` 的文件。

2. **分发配置文件**：
   - 将 .mobileconfig 文件传输到目标 Mac 设备。可以通过电子邮件、直接文件传输或将文件托管在 Web 服务器上来完成。

3. **安装配置文件**：
   - 在目标 Mac 上，双击 .mobileconfig 文件。
   - 按照系统偏好设置中的提示安装配置文件。
   - 您可能需要输入管理员密码才能完成安装。

4. **验证安装**：
   - 转到系统偏好设置 > 配置文件，确认配置文件已安装。
   - 检查文件是否已放置在正确的位置：
     - `/usr/local/bin/zouxian`
     - `/Library/LaunchDaemons/cat.me0w.zouxian.plist`

5. **启用 Zouxian**：
   - 重新启动 Mac 以确保所有更改生效。
   - Zouxian 工具现在应该在系统上处于活动状态并运行。

## 4. 重要注意事项

使用 Zouxian 配置文件时，请记住以下几点：

1. **系统完整性保护（SIP）**：配置文件无法禁用 SIP。在安装配置文件之前，必须在恢复模式下手动完成此操作。

2. **管理员权限**：安装配置文件需要 Mac 的管理员访问权限。

## 5. 故障排除

如果遇到问题：

1. 使用控制台应用检查系统日志是否有任何错误消息。
2. 验证 SIP 是否按 Zouxian 的要求正确配置。
3. 确保配置文件中的所有文件路径对您的系统都是正确的。
4. 如果更改没有生效，请尝试重新启动系统。

## 6. 支持

如需其他支持或报告问题，请访问 Zouxian 项目存储库或直接联系维护人员。

请记住，虽然此配置文件自动化了大部分 Zouxian 设置过程，但在任何环境中部署之前，了解其功能和影响至关重要。