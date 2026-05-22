# CBB Maritime Logistics - Dashboard

Sistema de gerenciamento logístico marítimo desenvolvido com PostgreSQL no Supabase e dashboard web em HTML, CSS e JavaScript.

## Integrantes

Beatriz Campanha, Beatriz Albuquerque, Caroline


## Tecnologias Utilizadas

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?logo=css&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)


## Funcionalidades

* Cadastro de empresas e viagens

* Dashboard web integrado ao banco de dados

* Oferece:
  * Visualização de viagens marítimas
  * Resumo de custos extras
  * Gerenciamento logístico


## Configuração do Projeto

### 1. Banco de Dados

Execute o arquivo `database.sql` no SQL Editor do Supabase.

### 2. Configuração da API

No arquivo `config.js`:

```javascript
const SUPABASE_URL = 'SUA_URL';
const SUPABASE_KEY = 'SUA_ANON_KEY';
```

### 3. Executar o Projeto

Abra o arquivo `index.html` no navegador.

## Segurança

O projeto utiliza Row Level Security (RLS) e policies de leitura.


## Licença

Projeto acadêmico desenvolvido para fins educacionais.
