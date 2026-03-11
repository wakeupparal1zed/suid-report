#!/bin/bash
set -euo pipefail

CTF_USER=${CTF_USER:-ctf}
CTF_PASS=${CTF_PASS:-ctf123}
FLAG=${FLAG}
CTF_HOME=/home/${CTF_USER}
SSH_PORT=${SSH_PORT:-22}

if ! id -u "$CTF_USER" >/dev/null 2>&1; then
  useradd -m -d "$CTF_HOME" -s /bin/bash "$CTF_USER"
fi

echo "${CTF_USER}:${CTF_PASS}" | chpasswd

if grep -qE '^#?Port ' /etc/ssh/sshd_config; then
  sed -ri "s/^#?Port .*/Port ${SSH_PORT}/" /etc/ssh/sshd_config
else
  echo "Port ${SSH_PORT}" >> /etc/ssh/sshd_config
fi

# Lock down common escalation paths; keep only the intended SUID binary
if [ -f /bin/su ]; then chmod 700 /bin/su; fi
if [ -f /usr/bin/su ]; then chmod 700 /usr/bin/su; fi
find / -xdev -type f -perm -4000 2>/dev/null | while read -r f; do
  if [ "$f" != "/usr/local/bin/run_report" ]; then
    chmod u-s "$f" 2>/dev/null || true
  fi
done

mkdir -p /opt/ctf/bin

FLAG_PATH=/root/flag.txt
printf "%s\n" "$FLAG" > "$FLAG_PATH"
chown root:root "$FLAG_PATH"
chmod 600 "$FLAG_PATH"

cat > /opt/ctf/bin/report.sh <<'SCRIPT'
#!/bin/bash
# Generates a harmless report
/bin/echo "status: ok" >> /var/log/report.log
SCRIPT

chown root:ctf /opt/ctf/bin/report.sh
chmod 775 /opt/ctf/bin/report.sh

cat >/etc/motd <<'MOTD'
ням
MOTD

cat >"$CTF_HOME"/WELCOME.txt <<'EOF2'

EOF2
chown ${CTF_USER}:${CTF_USER} "$CTF_HOME"/WELCOME.txt

unset FLAG

exec /usr/sbin/sshd -D -e
