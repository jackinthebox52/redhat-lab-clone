# Red Hat Lab Environment Dockerfile
FROM registry.access.redhat.com/ubi9/ubi:latest

RUN echo "workstation" > /etc/hostname

# Update system
RUN dnf update -y && \
    dnf install -y \
    sudo \
    vim \
    nano \
    wget \
    git \
    tar \
    gzip \
    unzip \
    which \
    man \
    bash-completion \
    net-tools \
    procps-ng \
    systemd \
    passwd \
    && dnf clean all

RUN useradd -m -s /bin/bash student && \
    echo "student:student" | chpasswd && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER student
WORKDIR /home/student

RUN mkdir -p ~/lab ~/scripts ~/projects

RUN echo 'export PS1="[\u@\h \W]$ "' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias la="ls -A"' >> ~/.bashrc && \
    echo 'alias l="ls -CF"' >> ~/.bashrc


# FAKE lab commands
RUN printf 'lab() {\n    if [ "$1" = "start" ]; then\n        echo\n        echo "Starting lab."\n        echo\n        echo " · Checking lab systems ................................................... SUCCESS"\n        echo " · Creating the temporary file ............................................ SUCCESS"\n        echo " · Backing up the bashrc file ............................................. SUCCESS"\n        echo\n    elif [ "$1" = "finish" ]; then\n        echo\n        echo "Finishing lab."\n        echo\n        echo " · Checking lab systems ................................................... SUCCESS"\n        echo " · Removing the temporary file ............................................ SUCCESS"\n        echo " · Restoring the bashrc file .............................................. SUCCESS"\n        echo\n    else\n        echo "Usage: lab {start|finish} [lab-name]"\n    fi\n}\n' >> ~/.bashrc
USER root

RUN echo "127.0.1.1 workstation" >> /etc/hosts

USER student

WORKDIR /home/student

CMD ["/bin/bash"]