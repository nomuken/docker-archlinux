FROM archlinuxjp/archlinux:latest
CMD /bin/bash
ENV PATH $PATH

RUN pacman -Sy archlinux-keyring --noconfirm && \
      pacman-key --refresh-keys && \
      pacman-db-upgrade && \
      trust extract-compat && \
      pacman -Syu --noconfirm && \
      yes y | pacman -Scc
