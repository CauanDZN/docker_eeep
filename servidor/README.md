# Configuração do Servidor com Docker

Este documento descreve como configurar um servidor com Docker para hospedar contêineres utilizando SSH e TTYD.

## Pré-requisitos

- Um servidor com sistema operacional Ubuntu (preferencialmente Ubuntu 20.04 ou superior).
- Acesso root ou permissões de sudo.
- Conexão à internet.

## Passo 1: Atualizar o Sistema

Atualize o sistema e instale as dependências necessárias:

```bash
sudo apt update
sudo apt upgrade -y
```

## Passo 2: Instalar o Docker

### 2.1: Instalar Dependências

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```

### 2.2: Adicionar a Chave do Repositório Docker

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

### 2.3: Adicionar o Repositório Docker

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

### 2.4: Instalar o Docker

```bash
sudo apt update
sudo apt install docker-ce -y
```

### 2.5: Adicionar seu Usuário ao Grupo Docker

Isso permite que você execute comandos Docker sem `sudo`.

```bash
sudo usermod -aG docker $USER
```

## Passo 3: Criar a Imagem Docker para SSH

### 3.1: Criar o Dockerfile para SSH

Crie um arquivo chamado `Dockerfile-SSH` com o seguinte conteúdo:

```dockerfile
# Dockerfile-SSH
FROM ubuntu:20.04

# Instalar SSH
RUN apt-get update && apt-get install -y openssh-server

# Criar diretório para o SSH
RUN mkdir /var/run/sshd

# Definir a senha do usuário root (opcional)
RUN echo 'root:senha' | chpasswd

# Permitir login como root
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expor a porta do SSH
EXPOSE 22

# Iniciar o serviço SSH
CMD ["/usr/sbin/sshd", "-D"]
```

### 3.2: Construir a Imagem SSH

No diretório onde o `Dockerfile-SSH` está localizado, execute o seguinte comando para construir a imagem:

```bash
docker build -t ubuntu-ssh -f Dockerfile-SSH .
```

## Passo 4: Criar a Imagem Docker para TTYD

### 4.1: Criar o Dockerfile para TTYD

Crie um arquivo chamado `Dockerfile-TTYD` com o seguinte conteúdo:

```dockerfile
# Dockerfile-TTYD
FROM ubuntu:latest

# Definir variável de ambiente para evitar interatividade durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências necessárias
RUN apt-get update && \
    apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev \
    && apt-get install -y ttyd bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar o TTYD a partir do repositório Git
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && cmake .. && make && make install && \
    cd ../.. && rm -rf ttyd

# Expor a porta do TTYD
EXPOSE 7681

# Comando para rodar o terminal via TTYD com a opção --writable
CMD ["/bin/bash", "-c", "script -f /var/log/tty-session.log -c 'ttyd --writable -p 7681 /bin/bash'"]
```

### 4.2: Construir a Imagem TTYD

No diretório onde o `Dockerfile-TTYD` está localizado, execute o seguinte comando para construir a imagem:

```bash
docker build -t ubuntu-ttyd -f Dockerfile-TTYD .
```

## Passo 5: Iniciar Contêineres

### 5.1: Iniciar o Contêiner SSH

Para iniciar o contêiner SSH, use o seguinte comando:

```bash
docker run -d -p 2222:22 --name meu_container_ssh ubuntu-ssh
```

### 5.2: Iniciar o Contêiner TTYD

Para iniciar o contêiner TTYD, use o seguinte comando:

```bash
docker run -d -p 7681:7681 --name meu_container_ttyd ubuntu-ttyd
```

## Conclusão

Agora você tem dois contêineres em execução: um com SSH e outro com TTYD. Você pode acessar o contêiner SSH usando um cliente SSH:

```bash
ssh root@localhost -p 2222
```

E você pode acessar o terminal via TTYD em um navegador, acessando `http://localhost:7681`.