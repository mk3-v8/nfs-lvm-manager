
![Example Image](NFS-LVM-Manager.png)

# NFS Logical Volume Manager

In the realm of server management, efficiency and automation are key. That's why I'm thrilled to share my latest project: NFS-LVM Manager. This suite of Bash scripts is designed to streamline the creation and removal of Logical Volumes (LVs) in a NFS environment, making it a must-have tool for Linux system administrators and enthusiasts alike.

## Why NFS-LVM Manager?
In a world where time is precious, NFS-LVM Manager is your ally in efficient storage management. It encapsulates complex commands into user-friendly scripts, ensuring that your NFS-LVM setup is up and running in no time, with minimal room for error.

## Key Features:
1. Simplified LV Management: Forget about the tedious command line syntax. Create or remove logical volumes with just a few keystrokes, making your storage management faster and more intuitive.
2. Automated Mounting and NFS Exporting: The script not only creates the LV but also takes care of filesystem creation, mounting, and NFS exporting. It's all done in one go, saving you from manual configuration.
3. Access Control: Define access control lists (ACLs) directly within the script, ensuring that only authorized networks can access your NFS shares.
4. Root Verification: To ensure system security, the scripts are designed to run only with root privileges, preventing unauthorized modifications to your storage configurations.
5. Error Handling: Built-in checks for common errors like existing LVs or mount directories, ensuring a smooth and error-free operation.

## Prerequisites

- These scripts assume that the system is running an NFS server.
- Ensure the `xfsprogs` package is installed on your system.

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/mk3-v8/nfs-lvm-manager.git
    ```

2. Change into the project directory:

    ```bash
    cd nfs-lvm-manager
    ```

3. Make the scripts executable and copy it to bin:

    ```bash
    chmod +x create.sh
    chmod +x remove.sh
    sudo cp create.sh /bin/create-lv
    sudo cp remove.sh /bin/remove-lv
    export PATH=$PATH:/bin
    ```

## Usage

### 1. Create Logical Volume (create.sh)

#### Syntax:

```bash
create-lv <lv_name> <lv_size>
```

### 2. Remove Logical Volume (remove.sh)
```bash
remove-lv <lv_name>
```
# Notes
- These scripts must be run as root (sudo or as a superuser).
- The create.sh script will create an XFS file system, update the /etc/fstab file, and restart the NFS server.
- The remove.sh script will unmount, remove the LV, update configuration files, and restart the NFS server.

### Feel free to contribute, report issues, or suggest improvements!
