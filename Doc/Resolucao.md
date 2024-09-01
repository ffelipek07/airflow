# Resolucao

# Versão do docker-compose

- Adicionado: A versão do docker-compose foi especificada como 3 na versão ajustada para garantir compatibilidade com recursos modernos do Docker.
```
version: '3'

```

# Variáveis de Ambiente
- AIRFLOW__CORE__SQL_ALCHEMY_CONN: Foi adicionado para definir a conexão com o banco de dados PostgreSQL.

```
AIRFLOW__CORE__SQL_ALCHEMY_CONN: 'postgresql+psycopg2://airflow:airflow@postgres/airflow'

```

# Caminhos dos Volumes
- Os caminhos dos volumes foram ajustados para usar a variável ${AIRFLOW_PROJ_DIR:-.}, proporcionando flexibilidade na configuração do diretório do projeto.

```

  volumes:

    - ${AIRFLOW_PROJ_DIR:-.}/dags:/opt/airflow/dags
    - ${AIRFLOW_PROJ_DIR:-.}/logs:/opt/airflow/logs
    - ${AIRFLOW_PROJ_DIR:-.}/plugins:/opt/airflow/plugins

```

# Configuração do Usuário
- O valor de user foi alterado para "${AIRFLOW_UID:-50000}:0", permitindo um controle mais flexível sobre o usuário e grupo que executam os processos no contêiner.

```
  user: "${AIRFLOW_UID:-50000}:0"
```

# Configuração do PostgreSQL

- POSTGRES_USER foi alterado de admin para airflow para corresponder ao usuário esperado pelo banco de dados.

```
POSTGRES_USER: airflow

```
# Healthcheck do Airflow Webserver
- O endpoint de healthcheck foi ajustado para http://localhost:8080/health para melhorar a verificação da saúde do serviço.

```
http://localhost:8080/health

```

# Inicialização (airflow-init)
- Foi adicionado um script de inicialização que verifica a versão do Airflow e os recursos disponíveis no sistema (memória, CPUs, espaço em disco) antes de configurar os diretórios e alterar permissões.

```
        function ver() {
          printf "%04d%04d%04d%04d" $${1//./ }
        }
        airflow_version=$$(AIRFLOW__LOGGING__LOGGING_LEVEL=INFO && gosu airflow airflow version)
        airflow_version_comparable=$$(ver $${airflow_version})
        min_airflow_version=2.2.0
        min_airflow_version_comparable=$$(ver $${min_airflow_version})
        if (( airflow_version_comparable < min_airflow_version_comparable )); then
          echo
          echo -e "\033[1;31mERROR!!!: Too old Airflow version $${airflow_version}!\e[0m"
          echo "The minimum Airflow version supported: $${min_airflow_version}. Only use this or higher!"
          echo
          exit 1
        fi
        if [[ -z "${AIRFLOW_UID}" ]]; then
          echo
          echo -e "\033[1;33mWARNING!!!: AIRFLOW_UID not set!\e[0m"
          echo "If you are on Linux, you SHOULD follow the instructions below to set "
          echo "AIRFLOW_UID environment variable, otherwise files will be owned by root."
          echo "For other operating systems you can get rid of the warning with manually created .env file:"
          echo "    See: https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html#setting-the-right-airflow-user"
          echo
        fi
        one_meg=1048576
        mem_available=$$(($$(getconf _PHYS_PAGES) * $$(getconf PAGE_SIZE) / one_meg))
        cpus_available=$$(grep -cE 'cpu[0-9]+' /proc/stat)
        disk_available=$$(df / | tail -1 | awk '{print $$4}')
        warning_resources="false"
        if (( mem_available < 4000 )) ; then
          echo
          echo -e "\033[1;33mWARNING!!!: Not enough memory available for Docker.\e[0m"
          echo "At least 4GB of memory required. You have $$(numfmt --to iec $$((mem_available * one_meg)))"
          echo
          warning_resources="true"
        fi
        if (( cpus_available < 2 )); then
          echo
          echo -e "\033[1;33mWARNING!!!: Not enough CPUS available for Docker.\e[0m"
          echo "At least 2 CPUs recommended. You have $${cpus_available}"
          echo
          warning_resources="true"
        fi
        if (( disk_available < one_meg * 10 )); then
          echo
          echo -e "\033[1;33mWARNING!!!: Not enough Disk space available for Docker.\e[0m"
          echo "At least 10 GBs recommended. You have $$(numfmt --to iec $$((disk_available * 1024 )))"
          echo
          warning_resources="true"
        fi
        if [[ $${warning_resources} == "true" ]]; then
          echo
          echo -e "\033[1;33mWARNING!!!: You have not enough resources to run Airflow (see above)!\e[0m"
          echo "Please follow the instructions to increase amount of resources available:"
          echo "   https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html#before-you-begin"
          echo
        fi

```

# Variáveis de Ambiente do Serviço airflow-init:
- As variáveis foram modificadas para usar a sintaxe ${VAR:-default}. Isso permite que os valores sejam definidos por variáveis de ambiente externas (_AIRFLOW_WWW_USER_USERNAME e _AIRFLOW_WWW_USER_PASSWORD). Se essas variáveis não forem definidas externamente, o valor padrão será "airflow". Esta abordagem oferece maior flexibilidade, pois permite que os valores sejam facilmente alterados sem modificar o arquivo de configuração.

```
_AIRFLOW_WWW_USER_USERNAME: ${_AIRFLOW_WWW_USER_USERNAME:-airflow}
_AIRFLOW_WWW_USER_PASSWORD: ${_AIRFLOW_WWW_USER_PASSWORD:-airflow}


```

# Volume do Serviço airflow-init:
-  O volume foi alterado para ${AIRFLOW_PROJ_DIR:-.}:/sources. Isso significa que o diretório no host que é mapeado para o contêiner é determinado pela variável de ambiente AIRFLOW_PROJ_DIR. Se AIRFLOW_PROJ_DIR não estiver definida, o diretório padrão será o diretório atual (.). Isso melhora a flexibilidade, permitindo que o diretório do projeto seja facilmente configurado a partir de uma variável de ambiente e garante que os arquivos e diretórios do Airflow (como logs, DAGs e plugins) estejam corretamente mapeados e acessíveis no contêiner.

```
volumes:
  - ${AIRFLOW_PROJ_DIR:-.}:/sources

```
