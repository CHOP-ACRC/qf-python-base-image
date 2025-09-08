FROM ubuntu:jammy

# Install python3 & pip 
RUN apt-get update && apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y unzip

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

# Install Databricks ODBC driver
RUN apt-get -y install libsasl2-modules libsasl2-modules-gssapi-mit
RUN curl --output databricks-odbc-driver.zip https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.9.1/SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip
RUN unzip databricks-odbc-driver.zip && rm databricks-odbc-driver.zip
RUN dpkg -i simbaspark_2.9.1.1001-2_amd64.deb && rm simbaspark_2.9.1.1001-2_amd64.deb

RUN echo "[Simba Spark ODBC Driver]\nDriver=/opt/simba/spark/lib/64/libsparkodbc_sb64.so" >> /etc/odbcinst.ini 

# Install Oracle ODBC driver

RUN mkdir /opt/oracle
WORKDIR /opt/oracle
RUN if [ $(uname -m) = "aarch64" ]; then \
    curl -o instantclient-basiclite-linux.zip https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basiclite-linux.arm64-23.7.0.25.01.zip && \
    curl -o instantclient-odbc-linux.zip https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-odbc-linux.arm64-23.7.0.25.01.zip; \
  elif [ $(uname -m) = "x86_64" ]; then \
    curl -o instantclient-basiclite-linux.zip https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basiclite-linux.x64-23.7.0.25.01.zip && \
    curl -o instantclient-odbc-linux.zip https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-odbc-linux.x64-23.7.0.25.01.zip; \
  fi
RUN unzip instantclient-basiclite-linux.zip && rm instantclient-basiclite-linux.zip
RUN unzip -o instantclient-odbc-linux.zip && rm instantclient-odbc-linux.zip

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_23_7:$LD_LIBRARY_PATH

WORKDIR /opt/oracle/instantclient_23_7
RUN ./odbc_update_ini.sh "/"

RUN apt-get update && apt-get install -y libaio1

# Install quarto
WORKDIR /root
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        curl -o quarto.deb -L "https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-arm64.deb"; \
    elif [ "$(uname -m)" = "x86_64" ]; then \
        curl -o quarto.deb -L "https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-amd64.deb"; \
    fi
RUN dpkg -i quarto.deb && \
    rm quarto.deb

RUN mkdir /req_install
WORKDIR /req_install
COPY requirements.txt requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/req_install"

RUN pip3 install --no-cache-dir -r ./requirements.txt

CMD ["python3"]