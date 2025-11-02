# Espaço-Já - Plataforma de Reserva de Espaços

## 👥 Equipe de Desenvolvimento

 Arthur Rodrigues – 22402586  
 Bernardo Almeida \- 22302808  
 Daniel Henrique \- 22400150  
 Rubens Moutinho \- 22300970  
 Pedro Coelho \- 12400653  
 Lucca Lourenço \- 22402225

## 📋 Sobre o Projeto

O **Espaço-Já** é uma plataforma completa para reserva de espaços compartilhados como salas de reunião, coworking, auditórios e espaços para eventos. Desenvolvido como **Progressive Web App (PWA)** com arquitetura moderna separando front-end (React) e back-end (Laravel API).

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
└── espaco-ja-laravel/          # Aplicação Laravel com React PWA
    ├── app/Http/Controllers/Api/  # Controllers da API REST
    ├── app/Models/               # Modelos Eloquent
    ├── database/migrations/      # Migrações do banco
    ├── database/seeders/         # Dados de exemplo
    ├── routes/api.php           # Rotas da API
    ├── resources/js/            # Componentes React
    ├── resources/views/         # Views Blade
    ├── public/manifest.json     # Manifest PWA
    ├── public/sw.js            # Service Worker
    └── public/icons/           # Ícones PWA
```

## 🚀 Como Executar o Projeto

### Pré-requisitos

- **PHP 8.2+** com extensões: sqlite, curl, json
- **Composer** (gerenciador de dependências PHP)
- **Node.js 18+** e **npm** (para React)
- **Navegador moderno** (Chrome, Firefox, Safari, Edge)

### Execução Simples

```bash
# Navegue até o diretório do Laravel
cd espaco-ja-laravel

# Inicie o servidor (assets já compilados)
php artisan serve
```

### Execução Completa (se necessário)

```bash
cd espaco-ja-laravel

# Instalar dependências
composer install
npm install

# Configurar banco de dados
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link

# Compilar assets (opcional)
npm run build

# Iniciar servidor
php artisan serve
```

### URLs de Acesso

- **Aplicação PWA**: http://127.0.0.1:8000
- **API Endpoints**: http://127.0.0.1:8000/api

## 📱 Instalação como PWA

1. **Acesse** `http://127.0.0.1:8000` no Chrome/Edge
2. **Clique** no ícone "Instalar" na barra de endereços
3. **Confirme** a instalação
4. **Use** como aplicativo nativo no seu dispositivo

## 👤 Dados de Teste

### Usuário Padrão
- **Email**: `usuario@exemplo.com`
- **Senha**: `123456`

### Espaços Disponíveis
- Sala de Reunião Premium (São Paulo) - R$ 50/hora
- Coworking Criativo (São Paulo) - R$ 30/hora
- Auditório Corporativo (São Paulo) - R$ 100/hora
- Sala de Treinamento (Rio de Janeiro) - R$ 40/hora
- Espaço para Eventos (Rio de Janeiro) - R$ 80/hora
- Sala de Videoconferência (Belo Horizonte) - R$ 35/hora

## ✨ Funcionalidades Implementadas

### 📱 Progressive Web App (PWA)
- **Instalável**: Funciona como app nativo
- **Offline**: Cache para uso sem internet
- **Responsivo**: Adapta-se a qualquer tela
- **Performance**: Carregamento otimizado
- **Ícones**: Personalizados para instalação

### 🔐 Sistema de Autenticação
- Registro de novos usuários
- Login com email e senha
- Autenticação via tokens JWT (Laravel Sanctum)
- Logout seguro
- Armazenamento seguro de credenciais

### 🏢 Gerenciamento de Espaços
- **Listagem**: Grid responsivo com paginação
- **Filtros**: Por cidade, capacidade e comodidades
- **Detalhes**: Informações completas, galeria de imagens
- **Localização**: Mapas interativos com marcadores
- **Busca**: Sistema de busca por texto livre
- **Upload**: Sistema de upload de imagens

### 📅 Sistema de Reservas
- **Criar Reserva**: Formulário com validação de disponibilidade
- **Verificação**: Checagem em tempo real de horários ocupados
- **Cálculo Automático**: Valor total baseado em horas
- **Histórico**: Visualização de todas as reservas do usuário
- **Cancelamento**: Possibilidade de cancelar reservas pendentes
- **Status**: Controle de estados (pendente, confirmada, cancelada)

### 👤 Perfil do Usuário
- Visualização de dados pessoais
- Histórico completo de reservas
- Gerenciamento de informações de contato
- Dashboard personalizado
- Meus espaços cadastrados

### 🎨 Interface do Usuário
- **Design Responsivo**: Funciona em desktop, tablet e mobile
- **Tema Moderno**: Interface limpa com Tailwind CSS
- **Navegação Intuitiva**: Menu responsivo e breadcrumbs
- **Feedback Visual**: Loading states e mensagens de erro/sucesso
- **Componentes Reutilizáveis**: Biblioteca de componentes React
- **PWA Ready**: Otimizado para instalação como app

## 🛠️ Tecnologias Utilizadas

### Backend (Laravel API)
- **Laravel 12** - Framework PHP moderno
- **Laravel Sanctum** - Autenticação de API com tokens
- **SQLite** - Banco de dados leve e portável
- **Eloquent ORM** - Mapeamento objeto-relacional
- **PHP 8.2** - Linguagem de programação

### Frontend (React PWA)
- **React 18+** - Biblioteca JavaScript para interfaces
- **Vite** - Build tool e dev server
- **PWA** - Progressive Web App
- **Service Worker** - Cache offline
- **Web App Manifest** - Configuração de instalação
- **Axios** - Cliente HTTP para requisições
- **React Router** - Roteamento SPA
- **Tailwind CSS** - Framework CSS utilitário

### Banco de Dados
```sql
-- Estrutura principal
users (id, name, email, password, whatsapp, tipo_usuario, descricao)
espacos (id, user_id, nome, descricao, preco_por_hora, capacidade, endereco, cidade, estado, cep, latitude, longitude, amenidades, imagens, ativo)
reservas (id, user_id, espaco_id, data, horario_inicio, horario_fim, valor_total, status, adultos, criancas, bebes, pets, observacoes)
```

## 📡 API Endpoints

### Autenticação
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/register` | Registro de usuário |
| POST | `/api/login` | Login |
| POST | `/api/logout` | Logout |
| GET | `/api/user` | Dados do usuário autenticado |

### Espaços
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/espacos` | Listar espaços (com filtros) |
| GET | `/api/espacos/{id}` | Detalhes do espaço |
| POST | `/api/espacos` | Criar espaço |
| PUT | `/api/espacos/{id}` | Atualizar espaço |
| DELETE | `/api/espacos/{id}` | Remover espaço |
| GET | `/api/espacos/{id}/disponibilidade` | Verificar disponibilidade |

### Reservas
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/reservas` | Minhas reservas |
| POST | `/api/reservas` | Criar reserva |
| PUT | `/api/reservas/{id}` | Atualizar reserva |
| DELETE | `/api/reservas/{id}` | Cancelar reserva |

### Upload
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/upload-image` | Upload de imagem |
| DELETE | `/api/delete-image` | Remover imagem |

### Dashboard
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/dashboard/meus-espacos` | Espaços do usuário |
| GET | `/api/dashboard/reservas-recebidas` | Reservas recebidas |

## 🔒 Segurança Implementada

### Backend
- **Validação de Dados**: Todas as entradas são validadas e sanitizadas
- **Autenticação Sanctum**: Tokens seguros para API
- **Middleware de Proteção**: Rotas protegidas por autenticação
- **CORS Configurado**: Permite requisições do frontend
- **Headers de Segurança**: X-Content-Type-Options, X-Frame-Options
- **Upload Seguro**: Validação de tipos e tamanhos de arquivo
- **SQL Injection**: Proteção via Eloquent ORM

### Frontend
- **Armazenamento Seguro**: Tokens em localStorage com validação
- **Validação de Formulários**: Validação client-side e server-side
- **Tratamento de Erros**: Feedback adequado para usuários
- **CSRF Protection**: Tokens CSRF em todas as requisições
- **XSS Protection**: Sanitização de dados de entrada

## 📱 Funcionalidades por Tela

### 🏠 Tela Inicial
- Hero section com call-to-action
- Busca rápida por localização
- Espaços em destaque (6 primeiros)
- Seção "Como Funciona" explicativa
- Design responsivo para PWA

### 🏢 Listagem de Espaços
- Grid responsivo com cards informativos
- Filtros por cidade, capacidade e comodidades
- Sistema de busca em tempo real
- Navegação para detalhes do espaço
- Paginação otimizada

### 📋 Detalhes do Espaço
- Galeria de imagens responsiva
- Informações completas (descrição, preço, capacidade)
- Mapa interativo com localização (Leaflet)
- Lista de comodidades disponíveis
- Formulário de reserva integrado
- Verificação de disponibilidade em tempo real
- Cálculo automático de valores

### 👤 Dashboard do Usuário
- Informações pessoais do usuário
- Histórico completo de reservas
- Status das reservas (pendente, confirmada, cancelada)
- Meus espaços cadastrados
- Opção de cancelamento de reservas
- Logout seguro

### 🔐 Login/Registro
- Formulário de login responsivo
- Opção de criar nova conta
- Validação de campos em tempo real
- Feedback visual de carregamento
- Redirecionamento automático após login

### ➕ Criar Espaço
- Formulário completo para cadastro
- Upload múltiplo de imagens
- Busca automática de coordenadas
- Seleção de comodidades
- Validação de dados em tempo real

## 🎯 Diferenciais do Projeto

### 1. **Progressive Web App**
- Instalável como aplicativo nativo
- Funciona offline com Service Worker
- Performance otimizada
- Experiência mobile nativa

### 2. **Arquitetura Moderna**
- Separação completa front-end/back-end
- API REST padronizada
- Escalabilidade horizontal
- Código limpo e organizado

### 3. **Experiência do Usuário**
- Interface intuitiva e responsiva
- Feedback visual em tempo real
- Navegação fluida entre telas
- Design moderno com Tailwind CSS

### 4. **Funcionalidades Avançadas**
- Verificação de disponibilidade em tempo real
- Mapas interativos com Leaflet
- Sistema de filtros avançados
- Upload de imagens com validação
- Cálculo automático de valores
- Busca geográfica automática

### 5. **Segurança Robusta**
- Autenticação com tokens JWT
- Validação completa de dados
- Headers de segurança
- Proteção contra XSS e CSRF
- Upload seguro de arquivos

### 6. **Performance Otimizada**
- Cache offline via Service Worker
- Assets compilados e minificados
- Lazy loading de componentes
- Paginação eficiente
- Otimização de imagens

## 🔄 Fluxo de Uso Típico

1. **Acesso**: Usuário acessa o PWA e pode instalá-lo
2. **Registro/Login**: Cria conta ou faz login
3. **Busca**: Navega pela tela inicial ou usa filtros
4. **Seleção**: Escolhe um espaço de interesse
5. **Detalhes**: Visualiza informações completas e localização
6. **Reserva**: Preenche formulário com data/horário
7. **Confirmação**: Sistema verifica disponibilidade e calcula valor
8. **Finalização**: Reserva é criada com status "pendente"
9. **Acompanhamento**: Usuário pode ver status no dashboard

## 🚀 Próximas Funcionalidades

- [ ] Sistema de pagamentos integrado
- [ ] Notificações push PWA
- [ ] Chat entre usuários e proprietários
- [ ] Sistema de avaliações e comentários
- [ ] Reservas recorrentes
- [ ] Relatórios para proprietários
- [ ] Integração com calendários externos
- [ ] Sistema de cupons e descontos
- [ ] Modo offline completo
- [ ] Sincronização automática

## 📞 Suporte e Contato

Para dúvidas sobre o projeto, entre em contato com a equipe de desenvolvimento através dos dados fornecidos no início deste documento.

---

**Projeto desenvolvido como trabalho acadêmico - 2025** 🎓  
**Progressive Web App - Instalável em qualquer dispositivo** 📱
