FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV XDG_RUNTIME_DIR=/tmp/runtime-vncuser

# Instala apenas o essencial
RUN apt-get update && \
    apt-get install -y \
        tigervnc-standalone-server \
        tigervnc-common \
        dbus-x11 \
        fluxbox \
        x11-utils && \        
    rm -rf /var/lib/apt/lists/*

# Cria usuário
RUN useradd -m -s /bin/bash vncuser && \
    echo "vncuser:vncuser" | chpasswd

# Criar diretórios e configurar TUDO como root
RUN mkdir -p /home/vncuser/.vnc && \
    mkdir -p /home/vncuser/.fluxbox && \
    mkdir -p /tmp/runtime-vncuser && \
    mkdir -p /home/vncuser/.Xauthority && \
    chmod 0700 /tmp/runtime-vncuser && \
    echo "password" | vncpasswd -f > /home/vncuser/.vnc/passwd && \
    chmod 600 /home/vncuser/.vnc/passwd

# Copiar arquivos como root
COPY ./menu /home/vncuser/.fluxbox/menu
COPY ./xstartup /home/vncuser/.vnc/xstartup
COPY ./entrypoint.sh /entrypoint.sh

# Ajustar permissões como root
RUN chown -R vncuser:vncuser /home/vncuser && \
    chmod +x /home/vncuser/.vnc/xstartup && \
    chmod +x /entrypoint.sh

# Mudar para usuário vncuser
USER vncuser
WORKDIR /home/vncuser

EXPOSE 5901

# CMD simplificado
ENTRYPOINT ["/entrypoint.sh" ]
#CMD ["vncserver", "-localhost", "no", "-geometry", "1920x1080", "-depth", "24", ":1", "-fg"]