FROM archlinuxjp/archlinux:start
RUN pacman -Syu --noconfirm
RUN pacman -Scc --noconfirm
