FROM archlinux:latest as base

# Install packages
FROM base AS install
RUN echo -en "[kde-unstable]\nInclude = /etc/pacman.d/mirrorlist\n$(cat /etc/pacman.conf)\n" > /etc/pacman.conf && \
    sed -i '/\[testing\]/a [extra-testing]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        git \
        clang \
        qt6-base \
        qt6-5compat \
        qt6-connectivity \
        qt6-declarative \
        qt6-doc \
        qt6-examples \
        qt6-imageformats \
        qt6-multimedia \
        qt6-quickeffectmaker \
        qt6-quicktimeline \
        qt6-svg \
        qt6-tools \
        qt6-wayland \
        polkit-qt6 \
        pkg-config \
        cmake \
        ninja \
        extra-cmake-modules \
        solid \
        networkmanager-qt \
        modemmanager-qt \
        libdrm \
        libinput \
        libxcvt \
        libdisplay-info \
        wayland-protocols

# User variables
ARG USERNAME=liriuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && pacman -Sy --noconfirm \
    && pacman -S --noconfirm sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
