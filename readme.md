## Install
### SSH + Yubikey, Git, and Stow
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y git vim stow yubikey-manager
ssh-add -K
git clone ssh://git@code.bonner.uk:2222/adambonneruk/linux.git Linux
rm ~/.bashrc ~/.ssh
stow -d ~/Linux -t ~ bash starship lazygit vscode ssh
```

### CLI Applications
```sh
sudo apt install -y btop curl figlet htop lolcat mc nwipe pass rclone smartmontools tmux tty-clock ufw tlp tlp-rdw
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
Network Connections > Wireguard > Import (+) "wg0.conf"
- MTU: ```1280```
- Search Domain: ```bonner.uk```
```

### GUI Applications
```sh
sudo apt install -y digikam dropbox filezilla keepass2 ksnip nemo-dropbox qbittorrent remmina veracrypt vlc wine-installer wireguard-tools xclip
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
Access via flag
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

### QEMU (Host)
Verify virtualization support
```sh
egrep -c '(vmx|svm)' /proc/cpuinfo
dmesg | grep -e DMAR -e IOMMU
```

Install packages
```sh
sudo apt install qemu-kvm libvirt-daemon-system virt-manager ovmf bridge-utils spice-client-gtk
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

## Debian Server Environment
### Add user (adam) to sudoers
```sh
# Substitute User to ROOT, Install Sudo and Vim, Add adam to sudoers
su
apt install sudo vim
sudo adduser adam sudo

# Substitute back to USER and check sources list
su - $USER
sudo vim /etc/apt/sources.list
```
