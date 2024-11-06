# PlataformaFin
Repositório do projeto da matéria MC656 (Engenharia de Software), que consiste em uma plataforma de controle financeiro.

Nomes:
- Mateus de Lima Almeida 242827
- Ana Carolina de Almeida Cardoso 246914
- Arthur Tsuyoshi Kina 260370
- Victor Hoshikawa Satoh 260711
- Matheus Seiji Luna Noda 230921

## Descrição da Arquitetura

Na figura abaixo, apresentamos o diagrama de componentes para modelar a arquitetura utilizada em nosso projeto. Nesse modelo, o usuário interage com a aplicação mobile, e cada requisição é tratada por uma feature específica.  

![MC656  Avaliação A4 - Diagrama C4 (5)](https://github.com/user-attachments/assets/fd0e4ac4-9065-4b26-9471-055233b78339)

O estilo arquitetural que optamos por utilizar foi o MVC (Model-View-Controller). Por isso, nossa aplicação foi dividida em três componentes independentes, cada uma com suas próprias funcionalidades e funções:

- **Model:** Modelo de dados e serviços da aplicação.
- **View:** Interface gráfica com o usuário, ou seja, o front-end do projeto.
- **Controller:** Controlador que invoca e sincroniza o modelo com a visão.

