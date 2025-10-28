<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class CreateSampleImages extends Command
{
    protected $signature = 'espacos:create-sample-images';
    protected $description = 'Cria imagens de exemplo para os espaços';

    public function handle()
    {
        $this->info('Criando imagens de exemplo...');
        
        // Cria o diretório se não existir
        if (!Storage::disk('public')->exists('espacos')) {
            Storage::disk('public')->makeDirectory('espacos');
        }

        // Cria 13 imagens de exemplo (uma para cada espaço do seeder)
        for ($i = 1; $i <= 13; $i++) {
            $imagePath = "espacos/exemplo-{$i}.jpg";
            
            if (!Storage::disk('public')->exists($imagePath)) {
                // Cria uma imagem simples com GD
                $this->createSampleImage($i);
                $this->info("Imagem criada: {$imagePath}");
            }
        }

        $this->info('Imagens de exemplo criadas com sucesso!');
    }

    private function createSampleImage($id)
    {
        // Cria uma imagem 400x300 com cor de fundo baseada no ID
        $width = 400;
        $height = 300;
        
        $image = imagecreate($width, $height);
        
        // Cores diferentes para cada espaço
        $colors = [
            [102, 51, 153],   // Roxo
            [51, 153, 102],   // Verde
            [153, 102, 51],   // Marrom
            [51, 102, 153],   // Azul
            [153, 51, 102],   // Rosa
            [102, 153, 51],   // Verde claro
            [153, 51, 51],    // Vermelho
            [51, 51, 153],    // Azul escuro
            [153, 153, 51],   // Amarelo
            [51, 153, 153],   // Ciano
            [153, 102, 153],  // Lilás
            [102, 102, 102],  // Cinza
            [204, 102, 0]     // Laranja
        ];
        
        $colorIndex = ($id - 1) % count($colors);
        $bgColor = imagecolorallocate($image, $colors[$colorIndex][0], $colors[$colorIndex][1], $colors[$colorIndex][2]);
        $textColor = imagecolorallocate($image, 255, 255, 255);
        
        // Preenche o fundo
        imagefill($image, 0, 0, $bgColor);
        
        // Adiciona texto
        $text = "Espaço {$id}";
        $fontSize = 5;
        $textWidth = imagefontwidth($fontSize) * strlen($text);
        $textHeight = imagefontheight($fontSize);
        $x = ($width - $textWidth) / 2;
        $y = ($height - $textHeight) / 2;
        
        imagestring($image, $fontSize, $x, $y, $text, $textColor);
        
        // Salva a imagem
        $path = storage_path("app/public/espacos/exemplo-{$id}.jpg");
        imagejpeg($image, $path, 90);
        imagedestroy($image);
    }
}