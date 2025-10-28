<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Espaco;
use App\Models\Reserva;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Criar usuário padrão
        $user = User::create([
            'name' => 'Usuário Exemplo',
            'email' => 'usuario@exemplo.com',
            'password' => Hash::make('123456'),
            'whatsapp' => '(11) 99999-9999',
            'tipo_usuario' => 'ambos',
            'descricao' => 'Usuário de exemplo para testes da plataforma',
        ]);
        
        // Criar usuário anfitrião
        $anfitriao = User::create([
            'name' => 'João Silva',
            'email' => 'anfitriao@exemplo.com',
            'password' => Hash::make('123456'),
            'whatsapp' => '(11) 98888-8888',
            'tipo_usuario' => 'anfitriao',
            'descricao' => 'Proprietário de espaços para eventos e reuniões',
        ]);
        
        // Criar usuário locatário
        $locatario = User::create([
            'name' => 'Maria Santos',
            'email' => 'locatario@exemplo.com',
            'password' => Hash::make('123456'),
            'whatsapp' => '(11) 97777-7777',
            'tipo_usuario' => 'locatario',
            'descricao' => 'Organizadora de eventos corporativos',
        ]);

        // Criar espaços de exemplo
        $espacos = [
            [
                'nome' => 'Sala de Reunião Premium',
                'descricao' => 'Sala moderna com equipamentos de última geração, ideal para reuniões executivas e apresentações importantes.',
                'preco_por_hora' => 50.00,
                'capacidade' => 12,
                'endereco' => 'Av. Paulista, 1000',
                'cidade' => 'São Paulo',
                'estado' => 'SP',
                'cep' => '01310-100',
                'latitude' => -23.5505,
                'longitude' => -46.6333,
                'amenidades' => ['Wi-Fi', 'Projetor', 'Ar Condicionado', 'Café', 'Estacionamento'],
                'imagens' => ['espacos/exemplo-1.jpg', 'espacos/exemplo-2.jpg'],
            ],
            [
                'nome' => 'Coworking Criativo',
                'descricao' => 'Espaço colaborativo com ambiente descontraído, perfeito para freelancers e startups.',
                'preco_por_hora' => 30.00,
                'capacidade' => 20,
                'endereco' => 'Rua Augusta, 500',
                'cidade' => 'São Paulo',
                'estado' => 'SP',
                'cep' => '01305-000',
                'latitude' => -23.5489,
                'longitude' => -46.6388,
                'amenidades' => ['Wi-Fi', 'Café', 'Impressora', 'Lounge'],
                'imagens' => ['espacos/exemplo-3.jpg'],
            ],
            [
                'nome' => 'Auditório Corporativo',
                'descricao' => 'Auditório completo para eventos, palestras e treinamentos corporativos.',
                'preco_por_hora' => 100.00,
                'capacidade' => 100,
                'endereco' => 'Av. Faria Lima, 2000',
                'cidade' => 'São Paulo',
                'estado' => 'SP',
                'cep' => '01452-000',
                'latitude' => -23.5733,
                'longitude' => -46.6892,
                'amenidades' => ['Wi-Fi', 'Projetor', 'Som', 'Ar Condicionado', 'Estacionamento', 'Catering'],
                'imagens' => ['espacos/exemplo-4.jpg', 'espacos/exemplo-5.jpg'],
            ],
            [
                'nome' => 'Sala de Treinamento',
                'descricao' => 'Sala equipada para treinamentos e workshops, com layout flexível.',
                'preco_por_hora' => 40.00,
                'capacidade' => 25,
                'endereco' => 'Rua Copacabana, 300',
                'cidade' => 'Rio de Janeiro',
                'estado' => 'RJ',
                'cep' => '22070-000',
                'latitude' => -22.9068,
                'longitude' => -43.1729,
                'amenidades' => ['Wi-Fi', 'Projetor', 'Flipchart', 'Ar Condicionado'],
                'imagens' => ['espacos/exemplo-6.jpg'],
            ],
            [
                'nome' => 'Espaço para Eventos',
                'descricao' => 'Espaço versátil para eventos sociais e corporativos, com decoração elegante.',
                'preco_por_hora' => 80.00,
                'capacidade' => 50,
                'endereco' => 'Av. Atlântica, 1500',
                'cidade' => 'Rio de Janeiro',
                'estado' => 'RJ',
                'cep' => '22021-000',
                'latitude' => -22.9711,
                'longitude' => -43.1822,
                'amenidades' => ['Wi-Fi', 'Som', 'Iluminação', 'Catering', 'Decoração'],
                'imagens' => ['espacos/exemplo-7.jpg', 'espacos/exemplo-8.jpg'],
            ],
            [
                'nome' => 'Sala de Videoconferência',
                'descricao' => 'Sala especializada em videoconferências com equipamentos de alta qualidade.',
                'preco_por_hora' => 35.00,
                'capacidade' => 8,
                'endereco' => 'Rua da Bahia, 1200',
                'cidade' => 'Belo Horizonte',
                'estado' => 'MG',
                'cep' => '30160-000',
                'latitude' => -19.9167,
                'longitude' => -43.9345,
                'amenidades' => ['Wi-Fi', 'Videoconferência', 'Ar Condicionado', 'Café'],
                'imagens' => ['espacos/exemplo-9.jpg'],
            ],
        ];

        $espacosIds = [];
        foreach ($espacos as $index => $espacoData) {
            $proprietario = $index < 3 ? $user->id : $anfitriao->id;
            $espaco = Espaco::create([
                'user_id' => $proprietario,
                ...$espacoData
            ]);
            $espacosIds[] = $espaco->id;
        }

        // Criar algumas reservas de exemplo
        $reserva1 = Reserva::create([
            'user_id' => $locatario->id,
            'espaco_id' => $espacosIds[0],
            'data' => now()->subDays(5),
            'horario_inicio' => '09:00',
            'horario_fim' => '11:00',
            'valor_total' => 100.00,
            'status' => 'confirmada',
        ]);

        $reserva2 = Reserva::create([
            'user_id' => $user->id,
            'espaco_id' => $espacosIds[1],
            'data' => now()->addDays(3),
            'horario_inicio' => '14:00',
            'horario_fim' => '18:00',
            'valor_total' => 120.00,
            'status' => 'pendente',
        ]);
        
        $reserva3 = Reserva::create([
            'user_id' => $locatario->id,
            'espaco_id' => $espacosIds[2],
            'data' => now()->subDays(10),
            'horario_inicio' => '19:00',
            'horario_fim' => '23:00',
            'valor_total' => 400.00,
            'status' => 'confirmada',
        ]);
        
        // Criar avaliações
        \App\Models\Avaliacao::create([
            'user_id' => $locatario->id,
            'espaco_id' => $espacosIds[0],
            'reserva_id' => $reserva1->id,
            'nota' => 5,
            'comentario' => 'Espaço excelente! Muito bem localizado e com ótima infraestrutura.',
        ]);
        
        \App\Models\Avaliacao::create([
            'user_id' => $locatario->id,
            'espaco_id' => $espacosIds[2],
            'reserva_id' => $reserva3->id,
            'nota' => 4,
            'comentario' => 'Auditório muito bom, apenas o ar condicionado poderia ser mais potente.',
        ]);
        
        // Criar mensagens
        \App\Models\Mensagem::create([
            'remetente_id' => $locatario->id,
            'destinatario_id' => $user->id,
            'reserva_id' => $reserva2->id,
            'mensagem' => 'Olá! Gostaria de confirmar os detalhes da minha reserva.',
        ]);
        
        \App\Models\Mensagem::create([
            'remetente_id' => $user->id,
            'destinatario_id' => $locatario->id,
            'reserva_id' => $reserva2->id,
            'mensagem' => 'Olá! Claro, sua reserva está confirmada. Qualquer dúvida, me avise!',
            'lida' => true,
        ]);
        
        // Criar pagamentos
        \App\Models\Pagamento::create([
            'reserva_id' => $reserva1->id,
            'user_id' => $locatario->id,
            'valor' => 100.00,
            'metodo_pagamento' => 'cartao_credito',
            'status' => 'aprovado',
            'transaction_id' => 'TXN_' . uniqid(),
            'data_pagamento' => now()->subDays(5),
        ]);
        
        \App\Models\Pagamento::create([
            'reserva_id' => $reserva3->id,
            'user_id' => $locatario->id,
            'valor' => 400.00,
            'metodo_pagamento' => 'pix',
            'status' => 'aprovado',
            'transaction_id' => 'PIX_' . uniqid(),
            'data_pagamento' => now()->subDays(10),
        ]);
    }
}