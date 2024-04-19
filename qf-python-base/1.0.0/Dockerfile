FROM ubuntu:jammy

# Install python3 & pip
RUN apt-get update && apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install msodbcsql18
RUN apt-get update && apt-get -y install curl lsb-release 
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN apt-get -y install unixodbc-dev


# Install Snowflake Driver 3.2.0
# Following instruction https://docs.snowflake.com/en/developer-guide/odbc/odbc
WORKDIR /root
RUN if [ $(uname -m) = "aarch64" ]; then \
        curl https://sfc-repo.snowflakecomputing.com/odbc/linuxaarch64/3.2.0/snowflake-odbc-3.2.0.aarch64.deb -o snowflake-odbc-3.2.0.deb; \
    elif [ $(uname -m) = "x86_64" ]; then \
        curl https://sfc-repo.snowflakecomputing.com/odbc/linux/3.2.0/snowflake-odbc-3.2.0.x86_64.deb -o snowflake-odbc-3.2.0.deb; \
    fi
RUN dpkg -i snowflake-odbc-3.2.0.deb && rm snowflake-odbc-3.2.0.deb
# Fix a config bug (only occurred in x86_64)
RUN sed -i 's/libodbcinst.so.1/libodbcinst.so.2/g' /usr/lib/snowflake/odbc/lib/simba.snowflake.ini

#Install Kerberos package (for Windows Integrated Authentication)
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install krb5-user

RUN mkdir /req_install
WORKDIR /req_install
COPY requirements.txt requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/req_install"

RUN pip3 install --no-cache-dir -r ./requirements.txt

CMD ["python3"]