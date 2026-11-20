# Gerenciador de Tarefas — P2 Programação Mobile

Aplicativo Flutter de gerenciamento de tarefas pessoais com **Firebase Authentication** (e-mail/senha), **Firebase Realtime Database**, **SharedPreferences** e temas claro/escuro.

## Funcionalidades

- Cadastro (nome, e-mail, senha), login e logout; a sessão é mantida pelo Firebase ao reabrir o app.
- Tela inicial com o nome do usuário e contagem de tarefas cadastradas, pendentes e concluídas.
- Menu lateral (Drawer) com Início, Minhas tarefas, Configurações, Sobre o aplicativo e Sair, mostrando nome e e-mail.
- CRUD de tarefas (título, descrição, vencimento, prioridade Baixa/Média/Alta, situação Pendente/Concluída).
- Listagem em `ListView` com cor da prioridade (verde/laranja/vermelho), checkbox para concluir/reabrir e detalhes ao tocar.
- Atualização em tempo real via listener `onValue` do Realtime Database.
- Tarefas salvas em `tarefas/{uid}` — cada usuário só lê/escreve as suas (ver `database.rules.json`).
- Tema claro/escuro salvo com SharedPreferences e aplicado em todas as telas.

## Estrutura

```
lib/
├── main.dart                  # inicialização, MaterialApp com temas e AuthGate
├── firebase_options.dart      # gerado pelo flutterfire configure
├── models/        usuario.dart, tarefa.dart
├── screens/       login, cadastro_usuario, home, tarefas, cadastro_tarefa, configuracoes
├── services/      auth_service, firebase_service (CRUD), preferences_service
├── widgets/       drawer_menu.dart
└── themes/        app_theme.dart (lightTheme, darkTheme, ThemeController)
```

## Como configurar o Firebase

1. Crie um projeto em <https://console.firebase.google.com>.
2. Em **Authentication → Método de login**, ative **E-mail/senha**.
3. Em **Realtime Database**, crie o banco e cole as regras de `database.rules.json` na aba **Regras**.
4. Instale as ferramentas e gere a configuração do app:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   flutterfire configure
   ```
   Isso substitui `lib/firebase_options.dart` (e cria `android/app/google-services.json`).
   Confira se o `firebase_options.dart` gerado contém `databaseURL`; se não tiver, adicione a URL do seu Realtime Database.

## Como executar

```bash
flutter pub get
flutter run
```

## Estrutura dos dados no Realtime Database

```
usuarios/
  {uid}: { nome, email }
tarefas/
  {uid}/
    {idTarefa}: { titulo, descricao, dataVencimento, prioridade, concluida }
```

## Capturas de tela

Adicione as imagens na pasta `screenshots/` (login, cadastro, home, drawer, lista, formulário, tema escuro).
