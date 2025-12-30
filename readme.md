#### Git and Vim
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y git vim
```

#### Stow
```sh
git clone http://example.com Linux && cd Linux
rm ~/.bashrc
stow bash starship
```

#### CLI Applications
```sh
sudo apt install -y btop figlet htop lolcat mc nwipe pass rclone smartmontools tmux tty-clock ufw tlp tlp-rdw yubikey-manager
```

##### Starship
```sh
curl -sS https://starship.rs/install.sh | sh
```

#### GUI Applications
```sh
sudo apt install -y  digikam dropbox filezilla keepass2 ksnip nemo-dropbox qbittorrent remmina veracrypt vlc wine-installer wireguard-tools xclip
```

#### Firewall
```sh
sudo ufw enable
sudo ufw allow from 10.0.0.0/8 to any port 22 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp
```

#### Header4
```sh
```