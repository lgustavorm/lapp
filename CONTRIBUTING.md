# Contribuindo para o Lapp

Obrigado por considerar contribuir para o Lapp! Este documento fornece diretrizes para contribuições.

## Como Contribuir

### 1. Fork e Clone

1. Faça um fork do repositório
2. Clone seu fork localmente:
   ```bash
   git clone https://github.com/seu-usuario/lapp.git
   cd lapp
   ```

### 2. Configuração do Ambiente

1. Instale o Flutter SDK (versão 2.19.0 ou superior)
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Configure o Firebase (opcional para desenvolvimento local)

### 3. Desenvolvimento

1. Crie uma branch para sua feature:
   ```bash
   git checkout -b feature/nova-funcionalidade
   ```

2. Faça suas alterações seguindo as diretrizes de código

3. Execute os testes:
   ```bash
   flutter test
   flutter analyze
   ```

4. Commit suas mudanças:
   ```bash
   git commit -m "feat: adiciona nova funcionalidade"
   ```

### 4. Pull Request

1. Push para sua branch:
   ```bash
   git push origin feature/nova-funcionalidade
   ```

2. Abra um Pull Request no GitHub

3. Aguarde a revisão e feedback

## Diretrizes de Código

### Convenções de Nomenclatura

- **Arquivos**: snake_case (ex: `auth_service.dart`)
- **Classes**: PascalCase (ex: `AuthService`)
- **Variáveis e métodos**: camelCase (ex: `userName`, `getUserData()`)
- **Constantes**: SCREAMING_SNAKE_CASE (ex: `MAX_RETRY_COUNT`)

### Estrutura de Commits

Use o formato convencional de commits:

- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Documentação
- `style:` - Formatação de código
- `refactor:` - Refatoração
- `test:` - Testes
- `chore:` - Tarefas de manutenção

### Testes

- Escreva testes para novas funcionalidades
- Mantenha a cobertura de testes
- Execute `flutter test` antes de fazer commit

### Análise de Código

- Execute `flutter analyze` antes de fazer commit
- Corrija todos os warnings e erros
- Mantenha o código limpo e legível

## Reportando Bugs

1. Use o template de issue do GitHub
2. Inclua informações detalhadas sobre o bug
3. Adicione screenshots se relevante
4. Descreva os passos para reproduzir o problema

## Sugerindo Funcionalidades

1. Use o template de feature request
2. Descreva a funcionalidade desejada
3. Explique o benefício para os usuários
4. Inclua mockups ou exemplos se possível

## Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a licença MIT.

## Contato

Se você tiver dúvidas sobre como contribuir, abra uma issue no GitHub ou entre em contato com os mantenedores.

---

Obrigado por contribuir para o Lapp! 🏁
