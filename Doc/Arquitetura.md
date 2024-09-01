# Arquitetura

# Arquitetura do Docker Compose para Airflow

- O Docker Compose configura uma stack do Apache Airflow com suporte a Celery para execução assíncrona de tarefas. A arquitetura inclui um banco de dados PostgreSQL, um broker Redis para comunicação entre o Airflow e os workers, e vários serviços Airflow para orquestração de tarefas.


## PostgreSQL

**Imagem:** postgres:13  
**Portas:** 5432:5432  
**Função:** Armazena metadados do Airflow, incluindo informações sobre DAGs e execuções de tarefas.  
**Volume:** postgres-db-volume para persistência dos dados.  
**Healthcheck:** Verifica a disponibilidade do banco de dados com `pg_isready`.

## Redis

**Imagem:** redis:latest  
**Exposição:** 6379  
**Função:** Servidor de mensagens usado pelo Airflow para gerenciar a fila de tarefas para o executor Celery.  
**Healthcheck:** Verifica a disponibilidade do Redis com `redis-cli ping`.

## Airflow Webserver

**Imagem:** apache/airflow:2.5.1  
**Comando:** webserver  
**Portas:** 8080:8080  
**Função:** Interface web para monitorar e gerenciar DAGs.  
**Healthcheck:** Verifica a disponibilidade da interface web com uma requisição `curl`.  
**Dependências:** Espera pelos serviços Redis, PostgreSQL e Airflow Init estarem prontos.

## Airflow Scheduler

**Imagem:** apache/airflow:2.5.1  
**Comando:** scheduler  
**Função:** Agendamento e execução de tarefas conforme definido nas DAGs.  
**Healthcheck:** Verifica a saúde do scheduler com `airflow jobs check`.  
**Dependências:** Espera pelos serviços Redis, PostgreSQL e Airflow Init estarem prontos.

## Airflow Worker

**Imagem:** apache/airflow:2.5.1  
**Comando:** celery worker  
**Função:** Executa as tarefas definidas nas DAGs.  
**Healthcheck:** Verifica a saúde do worker com um comando `celery`.  
**Dependências:** Espera pelos serviços Redis, PostgreSQL e Airflow Init estarem prontos.

## Airflow Triggerer

**Imagem:** apache/airflow:2.5.1  
**Comando:** triggerer  
**Função:** Aciona tarefas que necessitam de triggers específicos.  
**Healthcheck:** Verifica a saúde do triggerer com `airflow jobs check`.  
**Dependências:** Espera pelos serviços Redis, PostgreSQL e Airflow Init estarem prontos.

## Airflow Init

**Imagem:** apache/airflow:2.5.1  
**Entrypoint:** /bin/bash  
**Função:** Inicializa o ambiente Airflow, verifica a versão, configura permissões e configurações iniciais.  
**Comando:** Verifica recursos disponíveis e configura o ambiente.  
**Dependências:** É a dependência para outros serviços Airflow estarem prontos.

## Airflow CLI

**Imagem:** apache/airflow:2.5.1  
**Comando:** `airflow`  
**Função:** Fornece um terminal CLI para execução de comandos Airflow.  
**Perfis:** debug

## Flower

**Imagem:** apache/airflow:2.5.1  
**Comando:** `celery flower`  
**Portas:** 5555:5555  
**Função:** Interface web para monitoramento das tarefas do Celery.  
**Healthcheck:** Verifica a disponibilidade do Flower com uma requisição `curl`.  
**Dependências:** Espera pelo Airflow Init.

![airflow_architecture](https://github.com/user-attachments/assets/df1d858f-3bf9-4de0-9781-311b111afea6)

- [Arquitetura Container](Doc/Arquitetura-Container.drawio)

# Arquitetura AWS

![Arquitetura-AWS drawio](https://github.com/user-attachments/assets/c2f958d4-bd9c-4e1a-8147-d5da9783c4e3)


- [Arquitetura AWS](Doc/Arquitetura-AWS.drawio)
