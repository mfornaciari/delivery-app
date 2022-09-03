# Sistema de gerenciamento de entregas

Aplicação desenvolvida no âmbito da Turma 8 do [**TreinaDev**](<https://treinadev.com.br/>) para gerenciar entregas de produtos. Permite:

- Cadastrar transportadoras, seus veículos e suas tabelas de preços e prazos;
- Criar ordens de serviço, pesquisar preços e prazos praticados pelas transportadoras para aquela ordem e atribuí-la a uma transportadora;
- Aceitar ordens de serviço atribuídas à transportadora e atualizar periodicamente situação da entrega;
- Consultar situação de entrega sendo realizada.

[**Projeto associado no GitHub Projects**](https://github.com/users/mfornaciari/projects/1)

## Requisitos

- [**Ruby 3.1.2 +**](https://docs.ruby-lang.org/en/3.1/)
- [**Rails 7.0.3 +**](https://api.rubyonrails.org/)
- [**rspec-rails 5.1.2 +**](https://relishapp.com/rspec/rspec-rails/docs)
- [**capybara 3.37.1 +**](https://rubydoc.info/github/teamcapybara/capybara/master)
- [**devise 4.8.1 +**](https://github.com/heartcombo/devise)

## Executando a aplicação

1. Certifique-se de ter a versão correta do Ruby (3.1.2 +) instalada.
2. Clone o repositório ou baixe o arquivo .zip e descompacte-o.
3. Mude de diretório para a pasta principal do projeto.
4. Execute `bundle install` no terminal para instalar as dependências.
5. Execute `rails db:migrate db:seed` no terminal para preparar o banco de dados.
6. Execute `rails server` no terminal para iniciar a aplicação.
7. Acesse o endereço `localhost:3000` no navegador de sua preferência.

## Executando testes

1. Certifique-se de ter a versão correta do Ruby (3.1.2 +) instalada.
2. Clone o repositório ou baixe o arquivo .zip e descompacte-o.
3. Mude de diretório para a pasta principal do projeto.
4. Execute `bundle install` no terminal para instalar as dependências.
5. Execute `rails db:migrate` no terminal para preparar o banco de dados.
6. Execute `rspec` no terminal para iniciar os testes.
