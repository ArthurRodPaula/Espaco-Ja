# Espaço-Já - Plataforma de Reserva de Espaços

## 👥 Equipe de Desenvolvimento

- **Arthur Rodrigues** - Matrícula: 22402586
- **Bernardo Almeida** - Matrícula: 22302808
- **Daniel Henrique** - Matrícula: 2023003
- **Lucca Theophilo** - Matrícula: 22402225
- **Pedro Coelho** - Matrícula: 12400653
- **Rubens Moutinho** - Matrícula: 22400150


## 📋 Sobre o Projeto

O **Espaço-Já** é uma plataforma completa para reserva de espaços compartilhados como salas de reunião, coworking, auditórios e espaços para eventos. O sistema foi desenvolvido com arquitetura moderna separando front-end (Flutter) e back-end (Laravel API).

## 🏗️ Arquitetura do Sistema

```
┌─────────────────┐    HTTP/JSON    ┌─────────────────┐
│   Flutter App   │ ◄──────────────► │   Laravel API   │
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
├── espaco-ja-laravel/          # API Laravel (Backend)
│   ├── app/Http/Controllers/Api/  # Controllers da API REST
│   ├── app/Models/               # Modelos Eloquent
│   ├── database/migrations/      # Migrações do banco
│   ├── database/seeders/         # Dados de exemplo
│   ├── routes/api.php           # Rotas da API
│   └── config/                  # Configurações
└── espaco_ja_flutter/          # App Flutter (Frontend)
    ├── lib/models/              # Modelos de dados
    ├── lib/services/            # Comunicação com API
    ├── lib/screens/             # Telas do aplicativo
    ├── lib/widgets/             # Componentes reutilizáveis
    └── lib/utils/               # Constantes e utilitários
```

## 🚀 Como Executar o Projeto

### Pré-requisitos

- **PHP 8.2+** com extensões: sqlite, curl, json
- **Composer** (gerenciador de dependências PHP)
- **Flutter SDK 3.6+**
- **Navegador Chrome** (para execução web)

### Execução Rápida

```bash
# Execute o script automático
iniciar-projeto.bat
```

### Execução Manual

#### 1. Backend (Laravel API)

```bash
cd espaco-ja-laravel

# Instalar dependências
composer install

# Executar migrações e popular banco
php artisan migrate --force
php artisan db:seed --force

# Criar link para storage
php artisan storage:link

# Iniciar servidor da API
php artisan serve --host=127.0.0.1 --port=8000
```

#### 2. Frontend (Flutter)

```bash
cd espaco_ja_flutter

# Instalar dependências
flutter pub get

# Executar aplicativo web
flutter run -d chrome --web-port=3000
```

### URLs de Acesso

- **API Laravel**: http://127.0.0.1:8000
- **App Flutter**: http://localhost:3000

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
- **Tema Moderno**: Cores roxas com Material Design
- **Navegação Intuitiva**: Bottom navigation bar
- **Feedback Visual**: Loading states e mensagens de erro/sucesso
- **Mapas Interativos**: Integração com OpenStreetMap

## 🛠️ Tecnologias Utilizadas

### Backend (Laravel API)
- **Laravel 12** - Framework PHP moderno
- **Laravel Sanctum** - Autenticação de API com tokens
- **SQLite** - Banco de dados leve e portável
- **Eloquent ORM** - Mapeamento objeto-relacional
- **PHP 8.2** - Linguagem de programação

### Frontend (Flutter)
- **Flutter 3.6+** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **HTTP Package** - Requisições para API
- **Flutter Map** - Mapas interativos (OpenStreetMap)
- **Flutter Secure Storage** - Armazenamento seguro de tokens
- **Cached Network Image** - Cache de imagens
- **Intl** - Formatação de datas e números

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
- [ ] Versão mobile nativa (Android/iOS)
- [ ] Sistema de cupons e descontos

## 📞 Suporte e Contato

Para dúvidas sobre o projeto, entre em contato com a equipe de desenvolvimento através dos dados fornecidos no início deste documento.

---

**Projeto desenvolvido como trabalho acadêmico - 2025** 🎓

