
# espaco_ja

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# **Espaço-Já**

Aplicativo Flutter desenvolvido para facilitar a organização e o gerenciamento de espaços compartilhados.

## **🚀 Visão Geral**

O Espaço-Já é um aplicativo multiplataforma (Android e iOS) criado para otimizar o uso e a reserva de espaços compartilhados, como salas de estudo, coworkings e áreas comuns. O app permite:

* Visualizar espaços disponíveis em tempo real

* Fazer reservas rápidas e seguras

* Gerenciar reservas e histórico de uso

* Notificações para lembretes de reserva

## **🔐 Acesso**

* **Não existe usuário/senha padrão.** Cada pessoa precisa **criar sua própria conta** no app.

* **Fluxo:**

  1. Abra o app e toque em **Criar conta**.

  2. Preencha **Nome completo**, **Data de nascimento**, **CPF**, **(opcional) Telefone**, **E-mail** e **Senha** (mín. 6 caracteres).

  3. Aceite os termos e conclua o cadastro. Depois, faça login com **e-mail e senha**.

* **Esqueci minha senha:** use a opção **“Esqueci minha senha”** na tela de login para receber um e-mail de redefinição.

## **👥 Equipe**

Arthur Rodrigues – 22402586  
 Bernardo Almeida \- 22302808  
 Daniel Henrique \- 22400150  
 Rubens Moutinho \- 22300970  
 Pedro Coelho \- 12400653  
 Lucca Lourenço \- 22402225  
 **Turma:** 3A2

## **📁 Estrutura do Projeto**

`.`  
`├── android/`  
`├── ios/`  
`├── web/`  
`├── linux/`  
`├── macos/`  
`├── assets/`  
`│   └── images/                        # imagens usadas nas telas`  
`├── lib/`  
`│   ├── main.dart                      # entrada do app (inicializa Firebase)`  
`│   ├── firebase_options.dart          # gerado pelo flutterfire configure`  
`│   └── screens/`  
`│       ├── login_screen.dart          # login (Firebase Auth)`  
`│       ├── profile_setup_screen.dart  # cadastro completo (nome, CPF, data nasc., etc.)`  
`│       ├── opcoes_screen.dart         # navegação por abas (barra inferior)`  
`│       ├── mapa_screen.dart           # mapa (flutter_map / OpenStreetMap)`  
`│       ├── meus_locais.dart           # lista de locais do usuário`  
`│       ├── add_editar_local_screen.dart`  
`│       └── (opcional) detalhes_*      # telas de detalhes, se separadas`  
`├── pubspec.yaml`  
`└── test/`

## **⚡️ Como Executar o Projeto**

### **1\. Pré-requisitos**

* **Flutter SDK** (3.x ou superior) e **Dart** instalados

* **Firebase** configurado no projeto:

  * `firebase_core`, `firebase_auth`, `cloud_firestore`

  * Arquivo **`firebase_options.dart`** gerado com `flutterfire configure`

* Outras bibliotecas:

  * `flutter_map`, `latlong2`, `intl`

* Banco de dados: **Firebase Firestore**

### **2\. Instalação**

`# Clone o repositório`  
`git clone https://github.com/ArthurRodPaula/Espaco-Ja/tree/develop`  
`ATENÇÃO! SOMENTE A DEVELOP ESTÁ COM FIREBASE`

`# Acesse a pasta do projeto`  
`cd Espaco-Ja`

`# Baixe as dependências do Flutter`  
`flutter pub get`

`# (Se ainda não existir) Gere o firebase_options.dart`  
`# flutterfire configure`

### **3\. Execução**

`# Execute no navegador (Web)`  
`flutter run -d chrome`

`# ou emulador Android`  
`flutter run -d emulator-5554`

`# ou iOS (simulador)`  
`flutter run -d ios`  
---

## **Observações**

* Ative **Email/Password** em **Firebase Console → Authentication → Sign-in method**.

Confirme que `firebase_options.dart` está presente e que o `main.dart` chama:

 `await Firebase.initializeApp(`  
  `options: DefaultFirebaseOptions.currentPlatform,`  
`);`

* Para o mapa (OpenStreetMap via `flutter_map`), ajuste `userAgentPackageName` com o ID do seu app.

* Imagens usadas nas telas precisam estar referenciadas no `pubspec.yaml` (seção `assets:`).

* Se houver conflitos de fim de linha em Windows (LF/CRLF), use `git config core.autocrlf true`.

* Credenciais de teste: crie um usuário pela própria **tela de cadastro** do app.  
*   
* Lembre sempre de dar o comando flutter pub get antes de flutter run para ter certeza que todas as dependências estarão funcionando. Essa observação serve também caso o projeto não abra no navegador inicialmente. 

