FROM archlinuxjp/archlinux:latest
RUN pacman -Syu --noconfirm
RUN pacman -Scc --noconfirm
