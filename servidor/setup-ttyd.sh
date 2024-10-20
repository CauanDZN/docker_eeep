#!/bin/bash

# Função para verificar e instalar um pacote
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Instalando $1..."
        sudo apt install -y "$1"
    else
        echo "$1 já está instalado."
    fi
}

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências necessárias
echo "Instalando dependências..."
install_package apt-transport-https
install_package ca-certificates
install_package curl
install_package software-properties-common
install_package golang-go
install_package build-essential
install_package cmake
install_package git
install_package libjson-c-dev
install_package libwebsockets-dev
install_package ttyd
install_package bash

# Adicionar chave do repositório Docker
echo "Adicionando chave do repositório Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adicionar o repositório Docker
echo "Adicionando repositório Docker..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Instalar o Docker
echo "Instalando o Docker..."
sudo apt update && sudo apt install -y docker-ce

# Adicionar usuário atual ao grupo Docker
echo "Adicionando o usuário atual ao grupo Docker..."
sudo usermod -aG docker "$USER"

# Instalar Docker Compose
echo "Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Instalar LazyDocker
echo "Instalando LazyDocker..."
go install github.com/jesseduffield/lazydocker@latest

# Adicionar o Go bin ao PATH se não estiver presente
if ! echo "$PATH" | grep -q "$(go env GOPATH)/bin"; then
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# Verificar a instalação do Docker, Docker Compose e LazyDocker
echo "Verificando a instalação do Docker e Docker Compose..."
docker --version
docker-compose --version

echo "Verificando a instalação do LazyDocker..."
if command -v lazydocker &> /dev/null; then
    echo "LazyDocker instalado com sucesso."
else
    echo "Erro ao instalar o LazyDocker."
fi

# Instalar TTYD a partir do repositório Git, caso não esteja disponível no repositório
if ! command -v ttyd &> /dev/null; then
    echo "Instalando TTYD a partir do repositório Git..."
    git clone https://github.com/tsl0922/ttyd.git
    cd ttyd || exit
    mkdir build && cd build || exit
    cmake ..
    make
    sudo make install
    cd ../.. || exit
    rm -rf ttyd
else
    echo "TTYD já está instalado."
fi

# Conclusão
echo "Configuração do servidor concluída! Agora você pode iniciar o TTYD para cada dupla com o seguinte comando:"
echo "docker run -d -p 8080:7681 --name duplafulanocicrano ubuntu-ttyd"
echo "Se necessário, crie usuários e adicione-os ao grupo Docker conforme instruído anteriormente."
echo "E reinicie o sistema para que as alterações tenham efeito."
echo "sudo reboot"
