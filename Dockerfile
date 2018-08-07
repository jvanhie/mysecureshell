FROM debian:stable
MAINTAINER Pierre Mavro <deimos@deimos.fr>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" \
 -o Dpkg::Options::="--force-confold" install mysecureshell whois procps openssh-server
RUN apt-get clean
RUN mkdir /var/run/sshd
RUN chmod 4755 /usr/bin/mysecureshell

##################
# User Quick Try #
# Uncomment this #
##################
#RUN pass=$(mkpasswd -m sha-512 -s mssuser) && useradd -m -s /usr/bin/mysecureshell -p $pass mssuser
#RUN echo 'root:root' | chpasswd

##################
#   Production   #
##################
#Allow for custom mysecureshell config in /config/sftp.conf
RUN sed -i 's/#Include \/etc\/my_sftp_config_file/Include \/config\/sftp.conf/' /etc/ssh/sftp_config

# Start SSHd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
