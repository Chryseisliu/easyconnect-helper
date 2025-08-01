# EasyConnect Docker Helper Scripts 辅助脚本

## The Problem / 问题所在
Many universities and companies require the use of Sangfor's EasyConnect VPN client to access internal network resources.
许多大学和公司要求使用深信服（Sangfor）的 EasyConnect VPN 客户端来访问内部网络资源。

Unfortunately, the official Linux client is often outdated, difficult to install, and incompatible with modern Linux distributions like Ubuntu, Fedora, and Linux Mint.
不幸的是，其官方 Linux 客户端通常版本过时、难以安装，并且与现代 Linux 发行版（如 Ubuntu, Fedora, Linux Mint）不兼容。

This can lead to frustrating dependency issues, installation failures, and a non-functional VPN.
这会导致令人沮丧的依赖项问题、安装失败和VPN无法使用。

## The Solution / 解决方案
This project provides a pair of simple shell scripts to solve this problem by leveraging the brilliant [hagb/docker-easyconnect](https://github.com/Hagb/docker-easyconnect) Docker image, then automating the start & stop VPN proccesses.
本项目提供了一对简单的 Shell 脚本，通过利用已有的 [hagb/docker-easyconnect](https://github.com/Hagb/docker-easyconnect) Docker镜像, 并自动化连接和关闭vpn这两个步骤来解决此问题。

Instead of installing the buggy client directly on your system, these scripts run EasyConnect in a small, isolated Docker container.
这些脚本将 EasyConnect 运行在一个小型的、隔离的 Docker 容器中，而不是直接在您的宿主系统上安装这个有问题的客户端。

They then automatically configure your system's network routing so that you can access your internal network resources seamlessly, without needing to configure any proxies.
然后，它们会自动配置您系统的网络路由，使您可以无缝地访问内部网络资源，无需再进行任何代理配置。

**Key benefits: / 主要优点：**
- **No installation on your host system:** Keeps your Linux installation clean.
  **不在您的宿主系统上安装：** 保持您的 Linux 环境干净整洁。
- **Works on any modern Linux distro:** As long as you have Docker, it works.
  **适用于任何现代 Linux 发行版：** 只要您安装了 Docker，它就能工作。
- **Automated setup:** The scripts handle starting the container, logging in, and setting up network routes.
  **自动化配置：** 脚本会自动处理启动容器、登录和设置网络路由等步骤。
- **Global access:** Once connected, all applications on your computer can access the internal network without individual proxy settings.
  **全局访问：** 一旦连接，您计算机上的所有应用程序都可以访问内部网络，无需单独配置代理。

## Prerequisites / 先决条件
You must have **Docker** installed on your system. You can follow the official installation guide for your distribution: [Install Docker Engine](https://docs.docker.com/engine/install/).
您的系统上必须安装 **Docker**。您可以遵循您所用发行版的官方安装指南：[安装 Docker 引擎](https://docs.docker.com/engine/install/)。

You must add your user to the `docker` group to run commands without `sudo`.
您必须将您的用户添加到 `docker` 用户组，以便无需 `sudo` 即可运行命令。
  ```bash
  sudo usermod -aG docker $USER
  ```
**Important:** You must log out and log back in (or restart your computer) for this change to take effect.
**重要提示：** 您必须注销后重新登录（或重启电脑）才能使此项更改生效。

## Files / 文件列表
- `start_vpn.sh`: Connects to the VPN. / 连接到 VPN。
- `stop_vpn.sh`: Disconnects from the VPN and cleans up all related processes and network routes. / 断开 VPN 连接并清理所有相关进程和网络路由。

## Configuration / 配置
You need to edit the "USER CONFIGURATION" section at the top of **both** `start_vpn.sh` and `stop_vpn.sh`.
您需要编辑 `start_vpn.sh` 和 `stop_vpn.sh` **两个文件**顶部的“USER CONFIGURATION”部分。

```bash
# --- USER CONFIGURATION ---
# The only section you need to edit.
# --- 用户配置区 ---
# 这是您唯一需要编辑的部分。

# [1] Your VPN server address / 您的 VPN 服务器地址
VPN_URL="vpn.example.com"

# [2] Your VPN username / 您的 VPN 用户名
VPN_USER="your_username"

# [3] Your VPN password / 您的 VPN 密码
VPN_PASS="your_password"

# [4] Your organization's internal IP range (in CIDR format), which tells the script which traffic to send through the VPN.You may need to ask your IT department for the correct value.
INTERNAL_IP_RANGE="your_orgs_internal_IP_range"
# ---
# [4] 您所在机构的内部 IP 地址范围（使用 CIDR 格式）, 这个设置告诉脚本需要将哪些流量发送到 VPN。您可能需要询问您所在机构的 IT 部门以获取正确的值。
INTERNAL_IP_RANGE="your_orgs_internal_IP_range"
# --- END OF CONFIGURATION ---
```
**Note:** Ensure the `INTERNAL_IP_RANGE` value is the same in both `start_vpn.sh` and `stop_vpn.sh`.
**注意：** 请确保 `start_vpn.sh` 和 `stop_vpn.sh` 中的 `INTERNAL_IP_RANGE` 值是相同的。

## Usage / 使用方法
1.  **Configure:** Edit both `start_vpn.sh` and `stop_vpn.sh` with your details.
    **配置：** 编辑 `start_vpn.sh` 和 `stop_vpn.sh` 两个文件，填入您的信息。
2.  **Connect:** Open a terminal in the project folder and run:
    **连接：** 在项目文件夹中打开一个终端并运行：
    ```bash
    ./start_vpn.sh
    ```
3.  **Work:** Once it says "VPN Tunnel is Ready!", you can access your internal network.
    **工作：** 当脚本提示“VPN Tunnel is Ready!”后，您就可以访问内部网络了。
4.  **Disconnect:** When you're finished, open a terminal and run:
    **断开：** 当您使用完毕后，打开一个终端并运行：
    ```bash
    ./stop_vpn.sh
    ```

## License / 许可证
This project is released under the MIT License.
本项目根据 MIT 许可证发行。

