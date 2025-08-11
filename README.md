# 🏁 Lapp - App de Cronometragem de Voltas

App Flutter para cronometrar voltas em qualquer tipo de veículo (trackday, kart, moto, carro, etc.) usando GPS e detecção automática de linha de chegada.

## 🚀 Funcionalidades

- **🔐 Autenticação**: Login com Google ou email/senha
- **🗺️ Gestão de Pistas**: Criar e gerenciar pistas personalizadas
- **📍 Marcação de Linha de Chegada**: Interface para marcar a linha de chegada no mapa
- **⏱️ Cronometragem Automática**: Detecção automática de voltas ao cruzar a linha de chegada
- **📊 Dashboard**: Visualização de estatísticas e gráficos de performance
- **📈 Telemetria**: Captura de dados de velocidade, aceleração e força G
- **📤 Exportação**: Exportar resultados em CSV e compartilhar
- **💾 Persistência Local**: Armazenamento local de pistas e dados

## 🛠️ Tecnologias

- **Flutter** - Framework de desenvolvimento
- **Firebase** - Autenticação e Crashlytics
- **Google Maps** - Visualização e marcação de pistas
- **SQLite** - Banco de dados local
- **GPS/Geolocalização** - Detecção de posição e voltas
- **Sensores** - Captura de dados de telemetria

## 📱 Screenshots

_Screenshots do app serão adicionadas aqui_

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 2.19.0 ou superior)
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/lgustavorm/lapp.git
   cd lapp
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase** (opcional)
   - Crie um projeto no Firebase Console
   - Adicione as configurações do Firebase
   - Configure os arquivos de configuração

4. **Execute o app**
   ```bash
   flutter run
   ```

## 📋 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── firebase_options.dart     # Configurações do Firebase
├── models/                   # Modelos de dados
├── screens/                  # Telas da aplicação
├── services/                 # Serviços e lógica de negócio
└── helpers/                  # Helpers e utilitários
```

## 🔧 Configuração

### Permissões Necessárias

O app solicita as seguintes permissões:
- **Localização**: Para detectar posição e voltas
- **Armazenamento**: Para salvar dados e exportar resultados

## 📊 Como Usar

1. **Login**: Faça login com Google ou crie uma conta
2. **Criar Pista**: Toque no botão "+" para criar uma nova pista
3. **Marcar Linha de Chegada**: Toque no mapa para marcar o início e fim da linha de chegada
4. **Iniciar Sessão**: Selecione uma pista e inicie a cronometragem
5. **Cronometrar**: O app detectará automaticamente quando você cruzar a linha de chegada
6. **Ver Resultados**: Acesse o dashboard para ver estatísticas e exportar dados

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!
