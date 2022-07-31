FROM debian:11

RUN apt update -y

# Installation packages de base 
RUN apt install -y wget curl vim nano dos2unix locales git openjdk-11-jdk
RUN wget "https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
RUN tar -xzvf apache-maven-3.6.3-bin.tar.gz -C /opt
RUN rm apache-maven-3.6.3-bin.tar.gz

# Installation PostgreSQL
RUN apt install -y postgresql

# Installation ansible
RUN apt install -y ansible python3-psycopg2 
RUN ansible-galaxy collection install community.postgresql
RUN ansible-galaxy collection install community.general

# Configuration SSHD
RUN apt install -y openssh-server openssh-client ca-certificates 

RUN mkdir -p /run/sshd

RUN echo "root:password_@dmin" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \ 
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Run sshd at boot 
CMD [ "/usr/sbin/sshd" , "-D" ]