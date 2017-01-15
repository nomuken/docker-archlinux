FROM archlinuxjp/archlinux:start
CMD /bin/bash
ENV PATH $PATH
RUN pacman -Sy archlinux-keyring --noconfirm
RUN pacman-key --refresh-keys
RUN pacman-db-upgrade
RUN trust extract-compat
RUN pacman -Syu --noconfirm
