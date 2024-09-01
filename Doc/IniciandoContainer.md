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

# Fluxo de ar em execução

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


![image](https://github.com/user-attachments/assets/9de9bccc-0240-410c-a108-1bc8669d3cd5)


![image](https://github.com/user-attachments/assets/248aa45f-c436-466f-8708-41b647502ac0)


![image](https://github.com/user-attachments/assets/87ee1ea3-29a1-4796-b03c-760d72f2f19e)


