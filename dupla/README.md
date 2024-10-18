# Desafio de Docker para Duplas

Este documento orienta você e seu(sua) colega sobre como configurar e executar o desafio usando Docker.

## Pré-requisitos

- **Acesso ao servidor host via SSH**: Você precisará se conectar ao servidor onde os contêineres Docker estão hospedados.
- **Contas de usuário criadas no servidor**: Verifique com seu instrutor se suas contas de usuário foram criadas.

## Passo 1: Conectar ao Servidor

Conecte-se ao servidor usando SSH. O SSH permite que você acesse o servidor remotamente:

```bash
ssh duplaum@ip_do_servidor
```

- **duplaum**: Substitua pelo seu nome de usuário.
- **ip_do_servidor**: Substitua pelo endereço IP do servidor.

Esse acesso, o professor irá criar e disponibilizar as credenciais, tanto do nome de usuário, quanto da senha.

## Passo 2: Criar e Executar seu Contêiner

### 2.1: Criar um Novo Contêiner

Uma vez conectado, você pode criar e iniciar um novo contêiner Docker. Por exemplo, para criar um contêiner Ubuntu, execute:

```bash
docker run -it --name duplafulanocicrano ubuntu /bin/bash
```

- **docker run**: Este comando cria e inicia um novo contêiner.
- **-it**: Permite que você interaja com o contêiner através do terminal.
- **--name duplafulanocicrano**: Nomeia o contêiner para que você possa se referir a ele facilmente mais tarde.
- **ubuntu**: Indica a imagem base que o contêiner usará. Neste caso, a imagem oficial do Ubuntu.
- **/bin/bash**: Executa o shell Bash dentro do contêiner, permitindo que você interaja com ele.

### 2.2: Executar Comandos no Contêiner

Depois que o contêiner estiver em execução, você pode executar comandos dentro dele. Para acessar o contêiner em execução, use:

```bash
docker exec -it duplafulanocicrano /bin/bash
```

- **docker exec**: Este comando permite que você execute um novo comando em um contêiner em execução.
- **-it**: Permite interação com o terminal do contêiner.
- **duplafulanocicrano**: Nome do contêiner em que você deseja executar o comando.
- **/bin/bash**: Executa o shell Bash no contêiner, permitindo que você interaja com ele.

## Passo 3: Salvar e Compartilhar seu Trabalho

### 3.1: Parar o Contêiner

Quando terminar de trabalhar, você pode parar o contêiner com:

```bash
docker stop duplafulanocicrano
```

- **docker stop**: Este comando para um contêiner em execução.
- **duplafulanocicrano**: Nome do contêiner que você deseja parar.

### 3.2: Remover o Contêiner (Opcional)

Se você não precisar mais do contêiner, pode removê-lo com:

```bash
docker rm duplafulanocicrano
```

- **docker rm**: Este comando remove um contêiner que foi parado.
- **duplafulanocicrano**: Nome do contêiner que você deseja remover.

## Passo 4: Dicas Úteis

- **Listar Contêineres**: Para ver todos os contêineres, use:

  ```bash
  docker ps -a
  ```

  - **docker ps -a**: Mostra todos os contêineres, incluindo os que estão parados.

- **Ver Logs**: Para ver os logs do contêiner, use:

  ```bash
  docker logs duplafulanocicrano
  ```

  - **docker logs**: Mostra a saída do console do contêiner.
  - **duplafulanocicrano**: Nome do contêiner cujos logs você deseja ver.

## Conclusão

Siga os passos acima para realizar seu desafio. Se você encontrar problemas ou tiver perguntas, consulte seu instrutor ou verifique a documentação do Docker.

Boa sorte!