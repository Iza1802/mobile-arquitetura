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