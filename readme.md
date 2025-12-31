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

### Firewall
```sh
sudo ufw allow from 10.0.0.0/8 to any port 22 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp
sudo ufw enable
```

### GUI Applications
```sh
sudo apt install -y  digikam dropbox filezilla keepass2 ksnip nemo-dropbox qbittorrent remmina veracrypt vlc wine-installer wireguard-tools xclip
```

## Application Config and Notes
### Bash, Shell, Scripts, and Functions
```sh
chmod 700 ~/.bash/logon.sh
chmod 700 ~/.bash/onepwclip.sh
```

### Starship
- Download and Install [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads), Set Text Size 12
```sh
# Ubuntu
sudo apt install -y starship
# Linux Mint
curl -sS https://starship.rs/install.sh | sh
```

### VS Code
- Download [Visual Studio Code](https://code.visualstudio.com/docs/setup/linux) nd Install ```.deb```

Export Extensions
```sh
code --list-extensions > ~/extensions.txt
```
Import Extensions
```sh
cat extensions.txt | xargs -n 1 code --install-extension
```
### Ptyxis
Install via ```flatpak```
```sh
sudo apt install flatpak -y
flatpak install https://dl.flathub.org/repo/appstream/app.devsuite.Ptyxis.flatpakref
```
Access via flag
```sh
flatpak run app.devsuite.Ptyxis --tab
```

### Firefox
### Remmina
### LazyGit
Install from Source/Release on GitHub
```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```
### Wine
### digiKam
### ksnip
Access via flag
```sh
ksnip -r
```
### QEMU (Host)
### QEMU (Guest)
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

## Linux Mint Desktop Environment
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
