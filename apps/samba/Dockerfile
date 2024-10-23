# Use a lightweight base image
FROM debian:bookworm-slim AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# Install necessary packages for building Samba and smbclient
RUN apt update
RUN apt-get update && apt-get install -y \
        acl \
        apt-utils \
        attr \
        autoconf \
        bind9utils \
        binutils \
        bison \
        build-essential \
        ccache \
        chrpath \
        codespell \
        curl \
        debhelper \
        dnsutils \
        docbook-xml \
        docbook-xsl \
        flex \
        gcc \
        gdb \
        git \
        glusterfs-common \
        gnutls-bin \
        gzip \
        heimdal-multidev \
        hostname \
        jq \
        krb5-config \
        krb5-kdc \
        krb5-user \
        lcov \
        libacl1-dev \
        libarchive-dev \
        libattr1-dev \
        libavahi-common-dev \
        libblkid-dev \
        libbsd-dev \
        libcap-dev \
        libcephfs-dev \
        libcups2-dev \
        libdbus-1-dev \
        libglib2.0-dev \
        libgnutls28-dev \
        libgpgme11-dev \
        libicu-dev \
        libjansson-dev \
        libjs-jquery \
        libkeyutils-dev \
        libkrb5-dev \
        libldap2-dev \
        liblmdb-dev \
        libncurses5-dev \
        libpam0g-dev \
        libparse-yapp-perl \
        libpcap-dev \
        libpopt-dev \
        libreadline-dev \
        libsystemd-dev \
        libtasn1-bin \
        libtasn1-dev \
        libunwind-dev \
        liburing-dev \
        lmdb-utils \
        locales \
        lsb-release \
        make \
        mawk \
        mingw-w64 \
        patch \
        perl \
        perl-modules \
        pkg-config \
        procps \
        psmisc \
        python3 \
        python3-cryptography \
        python3-dbg \
        python3-dev \
        python3-dnspython \
        python3-gpg \
        python3-iso8601 \
        python3-markdown \
        python3-pexpect \
        python3-pyasn1 \
        python3-requests \
        python3-setproctitle \
        rng-tools \
        rsync \
        sed \
        shellcheck \
        shfmt \
        sudo \
        tar \
        tree \
        uuid-dev \
        wget \
        xfslibs-dev \
        xsltproc \
        xz-utils \
        zlib1g-dev

RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN apt-get -y clean
RUN rm -rf /var/lib/apt/lists/*

# Download and install the specified Samba version
RUN curl -fSL https://download.samba.org/pub/samba/stable/samba-${VERSION}.tar.gz -o samba-${VERSION}.tar.gz && \
    tar -xvzf samba-${VERSION}.tar.gz && \
    cd samba-${VERSION} && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf samba-${VERSION} samba-${VERSION}.tar.gz

# Stage 2: Final Image
FROM debian:bookworm-slim

# Install runtime dependencies for Samba and smbclient
RUN apt-get update && apt-get install -y \
    smbclient \
    libacl1 \
    libattr1 \
    libgnutls30 \
    libkrb5-3 \
    libldap-2.5-0 \
    liblmdb0 \
    libpopt0 \
    libreadline8 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy Samba from the builder stage
COPY --from=builder /usr/local/samba /usr/local/samba

# Create a non-root user
RUN useradd -M -s /bin/false smbuser


# Ensure the data directory exists and has appropriate permissions
RUN mkdir -p /data && \
    chown smbuser:smbuser /data && \
    chmod 0775 /data

# Expose the SMB port
EXPOSE 445

# Set the entrypoint to start the Samba server, expecting the user to provide their own smb.conf
ENTRYPOINT ["/usr/local/samba/sbin/smbd", "--foreground", "--no-process-group", "-s", "/etc/samba/smb.conf"]
