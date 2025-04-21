#/bin/sh
echo "Please type your user:"

read user

echo "Please type your full name (ex. Jean Dupont):"

read name

echo "Please type your email address (ex. jean.dupont@example.com):"

read email

echo "Please type your PGP signing key (if one, else let empty):"

read pgp

dnf install -y util-linux passwd cracklib-dicts python3-pip curl wget systemd procps sshpass

pip3 install "ansible-core>=2.16.0,<2.17.0" "ansible-lint"

user="${user,}"

useradd -G wheel $user

passwd $user

cat > /etc/wsl.conf << EOF
[boot]
systemd = true

[automount]
enabled = true
mountFsTab = false
root = /mnt/
options = "metadata,umask=22,fmask=11"

[network]
generateHosts = true
generateResolvConf = true

[interop]
enabled = true

[user]
default = $user
EOF

echo "%wheel   ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

rm -rf /var/cache/dnf/*
dnf clean all

cat << EOF > ansible/vars/custom.yml
username_on_the_host: $user
git:
  user:
    name: $name
    email: $email
$([ -z "$pgp" ] || echo "    signingkey: $pgp")
$(cat ansible/vars/custom.yml)
EOF

ansible-playbook ansible/main.yml -i localhost, -D
