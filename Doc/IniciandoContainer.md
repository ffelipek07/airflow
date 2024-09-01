# Iniciando

# Configurando o usuário correto do Airflow

- No Linux , o início rápido precisa saber o ID do usuário do host e precisa ter o ID do grupo definido como 0. Caso contrário, os arquivos criados em dags, logse pluginsserão criados com rootpropriedade do usuário. Você precisa certificar-se de configurá-los para o docker-compose:

```
mkdir -p ./dags ./logs ./plugins ./config
echo -e "AIRFLOW_UID=$(id -u)" > .env

```

# Inicializar o banco de dados

- Em todos os sistemas operacionais , você precisa executar migrações de banco de dados e criar a primeira conta de usuário. Para fazer isso, execute.

```
docker-compose up airflow-init

```

# Airflow em execução

- Agora você pode iniciar todos os serviços:

```
docker-compose up

```

# Acessando a interface web

- Depois que o cluster for iniciado, você pode efetuar login na interface web e começar a experimentar os DAGs.

O servidor web está disponível em: http://localhost:8080. A conta padrão tem o login airflowe a senha airflow.


```
http://localhost:8080

```

![image](https://github.com/user-attachments/assets/06de721b-b64d-4244-89cd-3ba18a812f37)

![image](https://github.com/user-attachments/assets/9c41d107-455d-45d8-91d7-31546be91fbf)

![image](https://github.com/user-attachments/assets/00eb3e29-2943-4dd2-a837-1f1baca4a3c1)



