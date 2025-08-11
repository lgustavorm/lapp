# 🏁 Lapp - App de Cronometragem de Voltas

Um aplicativo Flutter para cronometrar voltas em qualquer tipo de veículo (trackday, kart, moto, carro, etc.) usando GPS e detecção automática de linha de chegada.

## 🚀 Funcionalidades

- **🔐 Autenticação**: Login com Google ou email/senha
- **🗺️ Gestão de Pistas**: Criar e gerenciar pistas personalizadas
- **📍 Marcação de Linha de Chegada**: Interface intuitiva para marcar a linha de chegada no mapa
- **⏱️ Cronometragem Automática**: Detecção automática de voltas ao cruzar a linha de chegada
- **📊 Dashboard**: Visualização de estatísticas e gráficos de performance
- **📈 Telemetria**: Captura de dados de velocidade, aceleração e força G
- **📤 Exportação**: Exportar resultados em CSV e compartilhar
- **💾 Persistência Local**: Armazenamento local de pistas e dados

## 🛠️ Tecnologias Utilizadas

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
   - Configure o arquivo `google-services.json` (Android) e `GoogleService-Info.plist` (iOS)

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
│   ├── lap.dart
│   ├── session.dart
│   ├── telemetry_data.dart
│   └── track.dart
├── screens/                  # Telas da aplicação
│   ├── auth_wrapper.dart
│   ├── dashboard_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── mark_finish_line_screen.dart
│   ├── results_screen.dart
│   ├── session_screen.dart
│   └── track_list_screen.dart
├── services/                 # Serviços e lógica de negócio
│   ├── auth_service.dart
│   ├── gps_service.dart
│   ├── lap_detector.dart
│   └── telemetry_service.dart
└── helpers/                  # Helpers e utilitários
    ├── crashlytics_helper.dart
    └── database_helper.dart
```

## 🔧 Configuração

### Permissões Necessárias

O app solicita as seguintes permissões:

- **Localização**: Para detectar posição e voltas
- **Armazenamento**: Para salvar dados e exportar resultados

### Firebase Setup

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione as plataformas Android e iOS
3. Baixe os arquivos de configuração:
   - `google-services.json` para Android
   - `GoogleService-Info.plist` para iOS
4. Coloque os arquivos nas pastas apropriadas do projeto

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

## 👨‍💻 Autor

**lgustavorm**

- GitHub: [@lgustavorm](https://github.com/lgustavorm)

## 🙏 Agradecimentos

- Flutter team pelo framework incrível
- Firebase pela infraestrutura
- Comunidade Flutter pela documentação e exemplos

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!
