FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       openssh-server \
       ca-certificates \
       tzdata \
       nano \
       gcc \
       libc6-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd /opt/ctf

ARG CTF_USER=ctf
ARG CTF_HOME=/home/${CTF_USER}
RUN useradd -m -d ${CTF_HOME} -s /bin/bash ${CTF_USER}

RUN sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -ri 's|^#?PrintMotd.*|PrintMotd yes|' /etc/ssh/sshd_config \
    && sed -ri 's|^#?UsePAM.*|UsePAM yes|' /etc/ssh/sshd_config

COPY run_report.c /opt/ctf/run_report.c
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && gcc /opt/ctf/run_report.c -o /usr/local/bin/run_report \
    && chown root:root /usr/local/bin/run_report \
    && chmod 4755 /usr/local/bin/run_report

EXPOSE 22

ENV CTF_USER=ctf \
    CTF_PASS=ctf123 \
    FLAG=vsosh{testflag}

RUN printf "\n!\n\n" \
         "есть короче такие биты...\n" \
         > /etc/motd

CMD ["/entrypoint.sh"]
