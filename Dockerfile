FROM archlinux:latest

# init keyring
RUN pacman-key --init && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman-key --populate archlinux

# update system + some prereqs
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed base-devel git


# create user
ARG USER=zero
RUN useradd -m -g users -G wheel $USER
RUN sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
USER $USER
WORKDIR /home/$USER
RUN mkdir bin dev down work

# copy config
COPY --chown=$USER:users ./config/bash /home/$USER

# add paru (user required)
RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -sir --noconfirm && \
    cd && \
    rm -rf paru-bin && \
    paru -Scc --noconfirm

# base packages
RUN paru -S --noconfirm \
    binutils \
    curl \
    git \
    man-db \
    neovim \
    openssh \
    p7zip \
    unrar \
    unzip \
    vim \
    wget \
    zip

# dev packages
RUN paru -S --noconfirm \
    go \
    python \
    python-pipx \
    rustup
RUN pipx ensurepath
RUN rustup default stable

# generally useful cli/tui packages
RUN paru -S --noconfirm \
    atuin \
    bat \
    bottom \
    eza \
    fd \
    fzf \
    lazygit \
    procs \
    ripgrep \
    sd \
    tealdeer \
    xh \
    yazi

# recon packages
RUN paru -S --noconfirm \
    gobuster \
    nmap \
    rustscan \
    traceroute

# setup ssh
RUN mkdir /home/$USER/.ssh && \
    touch /home/$USER/.ssh/authorized_keys && \
    chmod 600 /home/$USER/.ssh/authorized_keys


ENTRYPOINT bash
