# Espaço-Já - Plataforma de Reserva de Espaços

## 👥 Equipe de Desenvolvimento

 Arthur Rodrigues – 22402586  
 Bernardo Almeida \- 22302808  
 Daniel Henrique \- 22400150  
 Rubens Moutinho \- 22300970  
 Pedro Coelho \- 12400653  
 Lucca Lourenço \- 22402225  

## 📋 Sobre o Projeto

O **Espaço-Já** é uma plataforma completa para reserva de espaços compartilhados como salas de reunião, coworking, auditórios e espaços para eventos. O sistema foi desenvolvido com arquitetura moderna separando front-end (React) e back-end (Laravel API).

## 🏗️ Arquitetura do Sistema

```
┌─────────────────┐    HTTP/JSON    ┌─────────────────┐
│   React App     │ ◄──────────────► │   Laravel API   │
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
└── espaco-ja-laravel/          # Aplicação Laravel com React (Full-Stack)
    ├── app/Http/Controllers/Api/  # Controllers da API REST
    ├── app/Models/               # Modelos Eloquent
    ├── database/migrations/      # Migrações do banco
    ├── database/seeders/         # Dados de exemplo
    ├── routes/api.php           # Rotas da API
    ├── resources/js/            # Componentes React
    ├── resources/views/         # Views Blade
    └── config/                  # Configurações
```

## 🚀 Como Executar o Projeto

### Pré-requisitos

- **PHP 8.2+** com extensões: sqlite, curl, json
- **Composer** (gerenciador de dependências PHP)
- **Node.js 18+** e **npm** (para React)
- **Navegador moderno** (Chrome, Firefox, Safari, Edge)

### Execução Rápida

```bash
# Navegue até o diretório do Laravel
cd espaco-ja-laravel

# Execute o setup completo
composer install
npm install
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link

# Inicie o servidor de desenvolvimento
php artisan serve
```

### Execução Manual

#### 1. Aplicação Laravel + React

```bash
cd espaco-ja-laravel

# Instalar dependências PHP
composer install

# Instalar dependências JavaScript
npm install

# Executar migrações e popular banco
php artisan migrate --force
php artisan db:seed --force

# Criar link para storage
php artisan storage:link

# Compilar assets do React (desenvolvimento)
npm run dev

# Em outro terminal, iniciar servidor Laravel
php artisan serve
```

### URLs de Acesso

- **Aplicação Completa**: http://127.0.0.1:8000
- **API Endpoints**: http://127.0.0.1:8000/api

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
- Interface intuitiva e responsiva

### 🎨 Interface do Usuário
- **Design Responsivo**: Funciona em desktop, tablet e mobile
- **Tema Moderno**: Interface limpa com Tailwind CSS
- **Navegação Intuitiva**: Menu responsivo e breadcrumbs
- **Feedback Visual**: Loading states e mensagens de erro/sucesso
- **Componentes Reutilizáveis**: Biblioteca de componentes React

## 🛠️ Tecnologias Utilizadas

### Backend (Laravel API)
- **Laravel 12** - Framework PHP moderno
- **Laravel Sanctum** - Autenticação de API com tokens
- **SQLite** - Banco de dados leve e portável
- **Eloquent ORM** - Mapeamento objeto-relacional
- **PHP 8.2** - Linguagem de programação

### Frontend (React)
- **React 18+** - Biblioteca JavaScript para interfaces
- **Vite** - Build tool e dev server
- **Axios** - Cliente HTTP para requisições
- **React Router** - Roteamento SPA
- **Tailwind CSS** - Framework CSS utilitário
- **React Hook Form** - Gerenciamento de formulários
- **React Query** - Gerenciamento de estado servidor

### Banco de Dados
```sql
-- Estrutura principal
users (id, name, email, password, whatsapp)
espacos (id, user_id, nome, descricao, preco_por_hora, capacidade, endereco, cidade, estado, cep, latitude, longitude, amenidades, ativo)
reservas (id, user_id, espaco_id, data, horario_inicio, horario_fim, valor_total, status, tipo, desconto, observacoes)
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

### Perfil
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/perfil` | Dados do perfil |
| PUT | `/api/perfil` | Atualizar perfil |

## 🔒 Segurança Implementada

### Backend
- **Validação de Dados**: Todas as entradas são validadas
- **Autenticação Sanctum**: Tokens seguros para API
- **Middleware de Proteção**: Rotas protegidas por autenticação
- **CORS Configurado**: Permite requisições do frontend
- **Relacionamentos Seguros**: Verificação de propriedade de recursos

### Frontend
- **Armazenamento Seguro**: Tokens em Flutter Secure Storage
- **Validação de Formulários**: Validação client-side
- **Tratamento de Erros**: Feedback adequado para usuários
- **Timeout de Requisições**: Evita travamentos

## 📱 Funcionalidades por Tela

### 🏠 Tela Inicial
- Hero section com call-to-action
- Busca rápida por localização
- Espaços em destaque (6 primeiros)
- Seção "Como Funciona" explicativa

### 🏢 Listagem de Espaços
- Grid responsivo com cards informativos
- Filtros por cidade, capacidade e comodidades
- Sistema de busca em tempo real
- Navegação para detalhes do espaço

### 📋 Detalhes do Espaço
- Galeria de imagens em carrossel
- Informações completas (descrição, preço, capacidade)
- Mapa interativo com localização
- Lista de comodidades disponíveis
- Formulário de reserva integrado
- Verificação de disponibilidade em tempo real

### 👤 Perfil do Usuário
- Informações pessoais do usuário
- Histórico completo de reservas
- Status das reservas (pendente, confirmada, cancelada)
- Opção de cancelamento de reservas
- Logout seguro

### 🔐 Login/Registro
- Formulário de login responsivo
- Opção de criar nova conta
- Validação de campos em tempo real
- Feedback visual de carregamento
- Redirecionamento automático após login

## 🎯 Diferenciais do Projeto

### 1. **Arquitetura Moderna**
- Separação completa front-end/back-end
- API REST padronizada
- Escalabilidade horizontal

### 2. **Experiência do Usuário**
- Interface intuitiva e responsiva
- Feedback visual em tempo real
- Navegação fluida entre telas

### 3. **Funcionalidades Avançadas**
- Verificação de disponibilidade em tempo real
- Mapas interativos
- Sistema de filtros avançados
- Cálculo automático de valores

### 4. **Segurança Robusta**
- Autenticação com tokens JWT
- Validação completa de dados
- Armazenamento seguro de credenciais

### 5. **Performance Otimizada**
- Cache de imagens
- Paginação de resultados
- Lazy loading de componentes

## 🔄 Fluxo de Uso Típico

1. **Acesso**: Usuário acessa o app e faz login
2. **Busca**: Navega pela tela inicial ou usa filtros
3. **Seleção**: Escolhe um espaço de interesse
4. **Detalhes**: Visualiza informações completas e localização
5. **Reserva**: Preenche formulário com data/horário
6. **Confirmação**: Sistema verifica disponibilidade e calcula valor
7. **Finalização**: Reserva é criada com status "pendente"
8. **Acompanhamento**: Usuário pode ver status no perfil

## 🚀 Próximas Funcionalidades

- [ ] Sistema de pagamentos integrado
- [ ] Notificações push em tempo real
- [ ] Chat entre usuários e proprietários
- [ ] Sistema de avaliações e comentários
- [ ] Upload de múltiplas imagens
- [ ] Reservas recorrentes
- [ ] Relatórios para proprietários
- [ ] Integração com calendários externos
- [ ] Progressive Web App (PWA)
- [ ] Sistema de cupons e descontos

## 📞 Suporte e Contato

Para dúvidas sobre o projeto, entre em contato com a equipe de desenvolvimento através dos dados fornecidos no início deste documento.

---

**Projeto desenvolvido como trabalho acadêmico - 2024** 🎓
