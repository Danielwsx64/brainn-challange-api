# Challange API

## Sobre
Essa API foi desenvolvida para atender ao desafio proposto pela equipe da
Brainn.co. Se trata de uma API para gerenciar tags de repositórios "curtidos" no
GitHub.

### Requerimentos
A API depende de uma base de dados Postgres e roda com `ruby 2.4.4`.

Alguns processos do projeto foram configurados com Docker (docker-compose). Mas
o uso é opicional.

## Rodando o projeto

### Docker/docker-compose
Foi utilizado o GNU Make para automação dos comandos. Para saber quais comandos
Docker estão sendo executados basta vizualizar o arquivo `Makefile`.

#### Comandos
Subir uma instancia da aplicação (http://localhost:4000):
```sh
make run
```

Rodar a suite de testes:
```
make test
```

Rodar scripts verificação de qualidade de código:
```
make quality
```

Subir um container com o console da aplicação
```
make console
```

Subir um container com o bash
```
make bash
```

### Sem Docker
Para realizar o setup da app é necessário ajustar as configurações do banco de
dados conforme o seu ambiente. As configurações podem ser setadas via variaveis
de ambiente no seu shell(terminal) ou editando o arquivo `.env` do projeto:

```
# Database configuration

export API_DATABASE_NAME=challange_api
export API_DATABASE_HOST=localhost
export API_DATABASE_USER=postgres
export API_DATABASE_PASS=
export API_DATABASE_POOL=5

```

Com o banco de dados configurado realize o setup da app com o comando:

```sh
bin/setup
```

#### Comandos
Subir uma instancia da aplicação (http://localhost:4000):
```sh
bundle exec rails s -p 4000
```

Rodar a suite de testes:
```
bundle exec rspec spec
```

Rodar scripts verificação de qualidade de código:
```
bundle exec rake check_rubycritc && bundle exec rubocop
```

Abrir o console da aplicação
```
bundle exec rails c
```

## Documentação da API
A documentação da API se encontra dentro do diretório `doc`, em formato `md` e
`html`.

O arquivo `doc/api_spec.md` é gerado pela gem
[Dox](https://github.com/infinum/dox) a partir das specs localizadas em
`spec/requests/` que estão com a tag `:dox`.

O arquivo `doc/api_spec.html` é gerado com
[Aglio](https://github.com/danielgtaylor/aglio) a partir do arquivo `md`.

Existe uma `task` para gerar a documentação:
```
bundle exec rake generate_api_docs
```
