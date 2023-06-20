if [[ ! -z $(which yum) ]]; then
    yum install jq -y
elif [[ ! -z $(which apt) ]]; then
    apt install jq -y
else
    echo "Unsupported system."
    exit 1;
fi

VER=$(curl -s "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | jq -r '.tag_name')
VERNUM=${VER//v/}

wget -O wgcf https://github.com/ViRb3/wgcf/releases/download/${VER}/wgcf_${VERNUM}_linux_amd64

chmod +x wgcf
