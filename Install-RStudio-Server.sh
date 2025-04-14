if [[ $(which yum) != '' ]]; then
    yum install jq -y
elif [[ $(which apt) != '' ]]; then
    apt install jq -y
else
    echo "Unsupported system."
    exit 1;
fi

VER=$(curl -s "https://api.github.com/repos/rstudio/rstudio/tags" | jq -r '.[0].name')
VER=${VER//+/-}
VER=${VER//v/}
FILEURL=https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${VER}-amd64.deb
FILENAME=rstudio-server-${VER}-amd64.deb

wget ${FILEURL}
apt install gdebi-core
gdebi ${FILENAME} -y
rm ${FILENAME}
