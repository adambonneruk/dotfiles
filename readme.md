## Install
### SSH + Yubikey, Git, and Stow
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y git vim stow yubikey-manager
ssh-add -K
git clone ssh://git@code.bonner.uk:2222/adambonneruk/linux.git Linux
rm ~/.bashrc ~/.ssh
stow -d ~/Linux -t ~ bash ksnip lazygit ssh starship tmux vscode
```

### CLI Applications
```sh
sudo apt install -y acpi btop curl ffmpeg figlet htop lolcat mc nwipe pass rclone smartmontools tmux tty-clock ufw tlp tlp-rdw
```

### Swap file
Check swappiness
```sh
cat /proc/sys/vm/swappiness
```
Set it lower (e.g. 10):
```sh
sudo sysctl vm.swappiness=10
```
Make permanent:
```sh
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
```

### Network
#### Firewall
```sh
sudo ufw allow from 10.0.0.0/8 to any port 22 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp
sudo ufw enable
```

#### Wireguard VPN
```
Network Connections > Wireguard > Import (+) > "wg0.conf"
- MTU: ```1280```
- Search Domain: ```bonner.uk```
```

### GUI Applications
```sh
sudo apt install -y audacity chromium digikam dropbox filezilla gimp keepass2 ksnip nemo-dropbox qbittorrent remmina veracrypt vlc wine-installer wireguard-tools xclip
```

### Firmware Updates
```sh
fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

## Application Config and Notes
### Bash, Shell, Scripts, and Functions
```sh
chmod 700 ~/.bash/logon.sh
chmod 700 ~/.bash/onepwclip.sh
```

### Starship
> Download and Install [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads), Set Text Size 12
```sh
curl -sS https://starship.rs/install.sh | sh
```

### Visual Studio Code
> Download [Visual Studio Code](https://code.visualstudio.com/docs/setup/linux) and Install ```.deb```

Export Extensions
```sh
code --list-extensions > ~/extensions.txt
```
Import Extensions
```sh
cat extensions.txt | xargs -n 1 code --install-extension
```

### Ptyxis
> _pronounced: “TIK-sis”, IPA: /ˈtɪk.sɪs/_

Install via ```flatpak```
```sh
sudo apt install flatpak -y
flatpak install https://dl.flathub.org/repo/appstream/app.devsuite.Ptyxis.flatpakref
```
Run with ```--tab``` flag
```sh
flatpak run app.devsuite.Ptyxis --tab
```

### Emoji Keyboard
Install via ```flatpak```
```sh
sudo apt install flatpak -y
flatpak install io.github.vemonet.EmojiMart
```
Run with ```--theme``` flag
```sh
flatpak run io.github.vemonet.EmojiMart --theme dark
```

### Firefox
TBC

### Remmina
TBC

### LazyGit
Install from Source/Release on GitHub
```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

### Wine
```sh
sudo apt install wine-installer -y
```

### digiKam
TBC

### ksnip
Access via flag, ```-r``` is select by **r**ectangle area
```sh
ksnip -r
```
Don't track recent file changes etc. in ```.conf``` file
```sh
git update-index --skip-worktree ksnip/.config/ksnip/ksnip.conf || true
```

### pass
```sh
gpg --quick-generate-key adam@bonner.uk
pass init adam@bonner.uk
pass insert 1password
```

### FIGlet Fonts
<!--[[Website](https://www.figlet.org/)]|[[Wiki](https://en.wikipedia.org/wiki/FIGlet)]-->
Download and "Install" (i.e. copy) FIGlet fonts
```sh
mkcd ~/Projects && git clone ssh://git@code.bonner.uk:2222/adambonneruk/figlet.git
cd figlet
git submodule update --init --recursive
sudo cp ./fonts/*.{flf,tlf} /usr/share/figlet/
```
Optionally test
```sh
chmod +x ./make.sh && ./make.sh > /dev/null
```

### QEMU (Host)
Verify virtualization support
```sh
egrep -c '(vmx|svm)' /proc/cpuinfo
dmesg | grep -e DMAR -e IOMMU
```

Install packages
```sh
sudo apt install qemu-kvm libvirt-daemon-system virt-manager ovmf bridge-utils spice-client-gtk virtiofsd
```
Add your user to libvirt + kvm groups:
```sh
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```
Restart host machine
```sh
sudo reboot now
```

### QEMU (Windows Guest)
TBC

### QEMU (Linux Guest)
Install and Start ```vdagent```
```sh
sudo apt update
sudo apt install spice-vdagent
sudo systemctl enable spice-vdagentd
sudo systemctl start spice-vdagentd
```
Restart
```sh
sudo restart now
```

### Docker and Docker Compose
```sh
sudo apt install docker.io docker-compose
```

## Linux Mint Desktop Environment
### Remove Software
```sh
sudo apt remove -y transmission transmission-gtk transmission-common
```

### Themes
TBC

### Keybindings
Backup
```sh
dconf dump /org/cinnamon/desktop/keybindings/ > keybindings.dconf
```
Restore
```sh
dconf load /org/cinnamon/desktop/keybindings/ < keybindings.dconf
```

### Login wallpaper
Copy with sudo, chown will be root:root
```sh
sudo cp /usr/share/backgrounds/example.jpg ~/Pictures/example.jpg
```

## Debian Server Environment
### Add user (adam) to sudoers
Substitute User to ROOT, Install Sudo and Vim, Add adam to sudoers
```sh
su
apt install sudo vim
sudo adduser adam sudo
```
Substitute back to USER and check sources list
```sh
su - $USER
sudo vim /etc/apt/sources.list
```

### Passwordless ```sudo```
run visduo with vim
```sh
sudo EDITOR=vim visudo -f /etc/sudoers.d/adam
```
add this line and save/close
```
adam ALL=(ALL) NOPASSWD:ALL
```
clear cache and verify
```sh
sudo -K
sudo whoami
```

### Disable Password Authentication (for SSH)
Edit SSHd Configuration
```sh
sudo vim /etc/ssh/sshd_config
```
```
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
AllowUsers adam
```
Validate SSHd config
```sh
sudo sshd -t
```
Restart SSHd
```sh
sudo systemctl reload ssh
```
Test
```sh
ssh -o PubkeyAuthentication=no adam@cargoship.bonner.uk
```

## Dell Latitude 5450 Config
### Hibernate Fixes
Note: multiple services can trigger wake
```sh
cat /proc/acpi/wakeup | grep enabled
```
Create Service
```sh
sudo vim /etc/systemd/system/acpi-disable-wakeups.service
```
Edit Contents
```ini
[Unit]
Description=Disable problematic ACPI wakeup sources
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c '\
echo XHCI > /proc/acpi/wakeup; \
echo RP11 > /proc/acpi/wakeup; \
echo TXHC > /proc/acpi/wakeup; \
echo TDM1 > /proc/acpi/wakeup; \
echo TRP2 > /proc/acpi/wakeup; \
echo TRP3 > /proc/acpi/wakeup'

[Install]
WantedBy=multi-user.target
```
Enable it
```sh
sudo systemctl daemon-reload
sudo systemctl enable acpi-disable-wakeups.service
```
Reboot
```sh
sudo reboot now
```
Verify
```sh
cat /proc/acpi/wakeup | grep enabled
```
Expected Output
```
AWAC	  S4	*enabled   platform:ACPI000E:00
LID0	  S3	*enabled   platform:PNP0C0D:00
PBTN	  S3	*enabled   platform:PNP0C0C:00
```
Notes:
- LID0: Lid switch, Required so opening the lid wakes the laptop
- PBTN: Power button, Required so you can wake it manually
- AWAC: ACPI Wake Alarm Clock, Used for: RTC alarms, Timers etc.
