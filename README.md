# mobile-arquitetura

---

**Em qual camada foi implementado o cache e por que?**

O cache fica na camada Data, pois ela gerencia o acesso a fontes de dados externas e locais. Isso isola a infraestrutura das regras de negócio, mantendo a camada Domain pura e focada apenas na lógica da aplicação.

---

**Por que o ViewModel nao realiza chamadas HTTP diretamente?**

O ViewModel foca apenas na gestão de estado da interface e não deve conhecer detalhes de infraestrutura. Delegar chamadas HTTP a camadas inferiores evita acoplamento, facilita testes unitários e permite a reutilização da lógica de negócio.

---

**O que aconteceria se a interface acessasse diretamente o datasource?**

Haveria um acoplamento crítico, onde mudanças na API quebrariam diretamente a UI. Além disso, a lógica de negócio ficaria espalhada pela interface, tornando a manutenção difícil e impedindo a troca de fontes de dados sem reescrever componentes visuais.

---

**Como essa arquitetura facilitaria a substituição da API por um banco de dados local?**

A arquitetura utiliza abstrações (interfaces) no Domain; logo, basta criar uma nova implementação de repositório no Data. Como o restante do app depende apenas do contrato da interface, a troca é transparente para as camadas de Presentation e Domain.

## Atividade 07 - Questionário sobre Estado 


    **1.O que significa gerenciamento de estado em uma aplicação Flutter?**
    Sincroniza os dados com a interface, garantindo que a UI seja atualizada automaticamente sempre que alguma informação mudar.

    **2.Por que manter o estado diretamente dentro dos widgets pode gerar problemas em aplicações maiores?**
    Porque o estado é perdido se o widget for destruído. Além disso, compartilhar dados entre widgets diferentes gera códigos complexos e difíceis de manter.

    **3.Qual é o papel do método notifyListeners() na abordagem Provider?**
    Avisar aos widgets "ouvintes" que o estado mudou, forçando a reconstrução da interface com os novos dados.

    **4.Qual é a principal diferença conceitual entre Provider e Riverpod?**
    O Provider depende da árvore de widgets. O Riverpod declara os providers globalmente, sendo independente da árvore, mais seguro contra falhas e fácil de testar.

    **5. No padrão BLoC, por que a interface não altera diretamente o estado da aplicação?**
    Para separar responsabilidades. A UI apenas dispara eventos, enquanto o BLoC centraliza a lógica de negócios, garantindo um fluxo de dados unidirecional e previsível.

    **6. Considere o fluxo do padrão BLoC:
        Evento → Bloc → Novo estado → Interface
        Qual é a vantagem de organizar o fluxo dessa forma?**
    Toda mudança tem uma origem clara. Isso centraliza a lógica e facilita muito a depuração, a manutenção e a criação de testes unitários.

    **7. Qual estratégia de gerenciamento de estado foi utilizada em sua implementação?**
    Padrão MVVM com ValueNotifier<ProductState>. O ViewModel gerencia o estado e a Page usa o ValueListenableBuilder para reagir automaticamente às mudanças.

    **8. Durante a implementação, quais foram as principais dificuldades encontradas?**
    Fazer o ValueNotifier atualizar a UI ao modificar um item já existente na lista. Foi necessário gerar uma nova lista com copyWith para forçar a detecção da mudança.
