FROM registry.fedoraproject.org/fedora:rawhide

ENV container=docker LANG=en_US.utf8 LANGUAGE=en_US.utf8 LC_ALL=en_US.utf8

RUN echo 'deltarpm = false' >> /etc/dnf/dnf.conf
RUN dnf update -y dnf
RUN sed -i 's/%_install_langs \(.*\)/\0:fr/g' /etc/rpm/macros.image-language-conf
RUN dnf install -y systemd
RUN dnf install -y sudo passwd hostname
RUN dnf install -y firewalld openssh-server
RUN dnf install -y glibc-langpack-en
RUN dnf install -y iptables procps-ng iproute iputils nss-tools NetworkManager
RUN dnf install -y wget git xz

RUN dnf clean all && rm -rf /root/rpms /root/srpms \
    && sed -i 's/.*PermitRootLogin .*/#&/g' /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && systemctl enable sshd

RUN sed -ri 's/(session\s+required\s+pam_loginuid.so)/# \1/' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh/

STOPSIGNAL RTMIN+3

VOLUME ["/run", "/tmp"]

ENTRYPOINT [ "/usr/sbin/init" ]
