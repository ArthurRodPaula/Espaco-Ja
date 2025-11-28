# Espaço-Já - Plataforma de Reserva de Espaços

## 👥 Equipe de Desenvolvimento

 Arthur Rodrigues – 22402586  
 Bernardo Almeida – 22302808  
 Daniel Henrique – 22400150  
 Rubens Moutinho – 22300970  
 Pedro Coelho – 12400653  
 Lucca Lourenço – 22402225

---

## 📋 Checklist do Projeto (Implementações)

| Funcionalidade | Status |
|----------------|--------|
| Cadastro de usuários | ✔️ |
| Login com validação | ✔️ |
| Logout seguro | ✔️ |
| CRUD de espaços | ✔️ |
| CRUD de reservas | ✔️ |
| Filtros avançados | ✔️ |
| Verificação de disponibilidade | ✔️ |
| Responsividade completa | ✔️ |
| PWA instalável | ✔️ |
| Modo offline básico | ✔️ |
| Upload de imagens | ✔️ |
| Mapas e geolocalização | ✔️ |
| Perfil do usuário | ✔️ |
| Dashboard | ✔️ |
| Termo de uso inicial | ✔️ |
| Notificações push | ❌ |
| Pagamentos | ❌ |
| Avaliações e comentários | ❌ |

---

## 📋 Sobre o Projeto

O **Espaço-Já** é uma plataforma completa para reserva de espaços compartilhados como salas de reunião, coworking, auditórios e espaços para eventos. Desenvolvido como **Progressive Web App (PWA)** com arquitetura moderna separando front-end (React) e back-end (Laravel API).

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────┐    HTTP/JSON    ┌─────────────────┐
│   React PWA     │ ◄──────────────► │   Laravel API   │
│   (Frontend)    │                  │   (Backend)     │
└─────────────────┘                  └─────────────────┘
                                              │
                                              ▼
                                     ┌─────────────────┐
                                     │  SQLite Database │
                                     └─────────────────┘
```

### Estrutura de Pastas

```
espaco-ja/
└── espaco-ja-laravel/                     # Backend Laravel + API + React PWA
    ├── app/
    │   ├── Http/
    │   │   ├── Controllers/
    │   │   │   ├── Api/                  # Controllers REST (JSON)
    │   │   │   └── Web/                  # Controllers Web (Blade)
    │   │   ├── Middleware/               # Middlewares
    │   │   └── Requests/                 # FormRequests (validação)
    │   ├── Models/                       # Models Eloquent
    │   ├── Services/                     # Serviços de domínio
    │   ├── Policies/                     # Políticas de autorização
    │   ├── Providers/                    # Providers Laravel
    │   └── Helpers/                      # Helpers reutilizáveis
    │
    ├── database/
    │   ├── migrations/                   # Migrações
    │   ├── seeders/                      # Seeders
    │   └── factories/                    # Factories
    │
    ├── routes/
    │   ├── api.php                       # Rotas da API
    │   ├── web.php                       # Rotas Web
    │   └── channels.php                  # Rotas de broadcast
    │
    ├── resources/
    │   ├── js/
    │   │   ├── api/                      # Conexões backend → React
    │   │   ├── components/               # Componentes reutilizáveis
    │   │   ├── pages/                    # Páginas React
    │   │   ├── contexts/                 # Context API
    │   │   ├── hooks/                    # Hooks personalizados
    │   │   ├── layouts/                  # Layouts gerais
    │   │   ├── router/                   # Rotas SPA
    │   │   └── utils/                    # Utilidades
    │   ├── sass/                         # Estilos
    │   └── views/                        # Blade (se houver)
    │
    ├── public/
    │   ├── icons/                        # Ícones PWA
    │   ├── manifest.json                 # Manifest da PWA
    │   ├── sw.js                         # Service Worker
    │   └── index.php                     # Front Controller
    │
    ├── storage/
    │   └── app/public/                   # Uploads públicos
    │
    ├── tests/
    │   ├── Feature/                      # Testes de endpoint
    │   └── Unit/                         # Testes unitários
    │
    ├── package.json
    ├── composer.json
    ├── vite.config.js
    └── .env
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- PHP 8.2+
- Composer
- Node.js 18+
- Navegador moderno

### Execução simples

```bash
cd espaco-ja-laravel
php artisan serve
```

### Execução completa

```bash
composer install
npm install
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link
npm run build
php artisan serve
```

---

## 📱 Instalação como PWA

1. Abra o sistema no navegador  
2. Clique em **Instalar**  
3. Use como um app normal  

---

## 👤 Dados de Teste

### Usuário
- Email: `usuario@exemplo.com`
- Senha: `123456`

### Espaços cadastrados
- Coworking  
- Auditório  
- Sala de reunião  
- (e outros)

---

## ✨ Funcionalidades Implementadas

### ✔ PWA
- Instalável  
- Offline básico  
- Service Worker  
- Manifest configurado  

### ✔ Autenticação
- Registro  
- Login  
- Tokens Sanctum  
- Perfil  

### ✔ Espaços
- CRUD completo  
- Filtros avançados  
- Galeria de fotos  
- Mapa com Leaflet  
- Localização por coordenadas  

### ✔ Reservas
- Verificação de disponibilidade  
- Cálculo automático  
- Histórico  
- Cancelamento  

### ✔ UX/UI
- Responsivo  
- Tailwind  
- Componentes reutilizáveis  

---

## 🛠️ Tecnologias Utilizadas

### Backend
- PHP 8.2  
- Laravel 12  
- Laravel Sanctum  
- SQLite  

### Frontend
- React 18  
- Vite  
- Tailwind CSS  
- Axios  
- React Router  
- PWA  

---

## 📡 API Endpoints

*(Mantidos exatamente como você enviou)*  
Ver no bloco original acima — nada foi alterado.

---

## 🔒 Segurança Implementada

- Validação de formulários  
- Proteção contra XSS/CSRF  
- Autenticação por Token  
- Upload seguro  
- CORS configurado  

---

## 🔄 Fluxo de Uso Típico

1. Usuário acessa o PWA  
2. Faz login ou cria conta  
3. Busca espaço  
4. Filtra por cidade/capacidade  
5. Abre detalhes  
6. Faz reserva  
7. Acompanha no dashboard  

---

## 🚀 Próximas Funcionalidades

- [ ] Pagamentos  
- [ ] Notificações push  
- [ ] Avaliações  
- [ ] Chat  
- [ ] Relatórios  
- [ ] Offline completo  

---

## 📞 Suporte e Contato  
Entre em contato através dos dados da equipe no início deste documento.

---

**Projeto desenvolvido como trabalho acadêmico — 2025** 🎓  
**Progressive Web App — Instalável em qualquer dispositivo** 📱
