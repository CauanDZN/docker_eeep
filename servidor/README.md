# Configuração do Servidor Host

Este documento descreve o processo de configuração do servidor host que irá hospedar os contêineres Docker para o desafio.

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

## Passo 3: Instalar o Docker Compose

### 3.1: Baixar a Última Versão do Docker Compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

### 3.2: Dar Permissões de Execução

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

## Passo 4: Verificar a Instalação

Verifique se o Docker e o Docker Compose foram instalados corretamente:

```bash
docker --version
docker-compose --version
```

## Passo 5: Criar Usuários para os Alunos

Crie usuários para cada dupla de alunos no sistema:

```bash
sudo adduser duplaum
sudo adduser dupladois
```

Adicione os usuários ao grupo Docker:

```bash
sudo usermod -aG docker duplaum
sudo usermod -aG docker dupladois
```

## Passo 6: Configurar SSH

Certifique-se de que o SSH está instalado e ativo para que os alunos possam acessar o servidor:

```bash
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
```

## Passo 7: Criar a Imagem Docker

Crie um arquivo chamado `Dockerfile` com o seguinte conteúdo:

```dockerfile
# Dockerfile
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

### 7.1: Construir a Imagem

No diretório onde o `Dockerfile` está localizado, execute o seguinte comando para construir a imagem:

```bash
docker build -t ubuntu .
```

## Conclusão

O servidor está agora configurado e pronto para hospedar contêineres Docker para o desafio. Os alunos devem ser capazes de acessar seus contêineres usando suas contas individuais. Além disso, a imagem Docker com o SSH está pronta para ser utilizada.

Se você tiver alguma dúvida, consulte a documentação do Docker ou peça ajuda ao seu instrutor.