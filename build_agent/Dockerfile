# Use Microsoft's VSTS agent docker image as a base https://hub.docker.com/r/microsoft/vsts-agent/
FROM microsoft/vsts-agent:ubuntu-16.04

# Install azure cli 2.0
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list
# due to error being thrown currently disabled
# RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
RUN apt-get install apt-transport-https
RUN apt-get update -y && apt-get install azure-cli -y --allow-unauthenticated

# Change this URL to the exact PowerShell version you want to install, https://github.com/PowerShell/PowerShell/releases
ENV POWERSHELL_DOWNLOAD_URL https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/powershell_6.0.2-1.ubuntu.16.04_amd64.deb
ENV DotNetFramework exists

RUN curl -L $POWERSHELL_DOWNLOAD_URL --output powershell_linux.deb
RUN dpkg -i powershell_linux.deb && apt-get install -f
RUN rm powershell_linux.deb --force

# default command to run
CMD ["./start.sh"]