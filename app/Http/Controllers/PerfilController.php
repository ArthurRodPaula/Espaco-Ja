<?php

namespace App\Http\Controllers;

use App\Models\Espaco;
use Illuminate\Http\Request;

class PerfilController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $reservas = $user->reservas()->with('espaco')->orderBy('created_at', 'desc')->get();
        $meusEspacos = $user->espacos()->orderBy('created_at', 'desc')->get();
        
        return view('perfil.index', compact('reservas', 'meusEspacos'));
    }

    public function criarEspaco()
    {
        return view('perfil.criar-espaco');
    }

    public function storeEspaco(Request $request)
    {
        $request->validate([
            'nome' => 'required|string|max:255',
            'descricao' => 'required|string',
            'endereco' => 'required|string',
            'cidade' => 'required|string',
            'estado' => 'required|string',
            'cep' => 'required|string',
            'preco_hora' => 'required|numeric|min:0',
            'capacidade' => 'required|integer|min:1',
            'comodidades' => 'required|array|min:1',
            'imagens' => 'required|array|min:1|max:10',
            'imagens.*' => 'image|max:2048'
        ], [
            'comodidades.required' => 'Selecione pelo menos uma comodidade.',
            'comodidades.min' => 'Selecione pelo menos uma comodidade.',
            'imagens.required' => 'Adicione pelo menos uma imagem.',
            'imagens.min' => 'Adicione pelo menos uma imagem.'
        ]);

        $data = $request->all();
        $data['user_id'] = auth()->id();
        
        // Buscar coordenadas pelo endereço
        $endereco_completo = $data['endereco'] . ', ' . $data['cidade'] . ', ' . $data['estado'] . ', ' . $data['cep'];
        $coordenadas = $this->buscarCoordenadas($endereco_completo);
        
        if ($coordenadas) {
            $data['latitude'] = $coordenadas['lat'];
            $data['longitude'] = $coordenadas['lon'];
        }
        
        $espaco = Espaco::create($data);

        if ($request->hasFile('imagens')) {
            foreach ($request->file('imagens') as $index => $imagem) {
                $caminho = $imagem->store('espacos', 'public');
                $espaco->imagens()->create([
                    'caminho' => $caminho,
                    'ordem' => $index
                ]);
            }
        }

        return redirect()->route('perfil')->with('success', 'Espaço adicionado com sucesso!');
    }

    private function buscarCoordenadas($endereco)
    {
        $endereco_encoded = urlencode($endereco);
        $url = "https://nominatim.openstreetmap.org/search?format=json&q={$endereco_encoded}&limit=1";
        
        $context = stream_context_create([
            'http' => [
                'header' => "User-Agent: EspacoJa/1.0\r\n"
            ]
        ]);
        
        $response = @file_get_contents($url, false, $context);
        
        if ($response) {
            $data = json_decode($response, true);
            if (!empty($data)) {
                return [
                    'lat' => (float) $data[0]['lat'],
                    'lon' => (float) $data[0]['lon']
                ];
            }
        }
        
        return null;
    }

    public function buscarCoordenadasAjax(Request $request)
    {
        $endereco = $request->get('endereco');
        $coordenadas = $this->buscarCoordenadas($endereco);
        
        return response()->json($coordenadas);
    }

    public function updateWhatsapp(Request $request)
    {
        $request->validate([
            'whatsapp' => 'nullable|string|regex:/^[0-9]{10,15}$/|max:15'
        ], [
            'whatsapp.regex' => 'WhatsApp deve conter apenas números (10-15 dígitos)'
        ]);

        $whatsapp = $request->whatsapp ? preg_replace('/[^0-9]/', '', $request->whatsapp) : null;
        
        auth()->user()->update(['whatsapp' => $whatsapp]);
        return back()->with('success', 'WhatsApp atualizado com sucesso!');
    }

    public function editarEspaco(Espaco $espaco)
    {
        if ($espaco->user_id !== auth()->id()) {
            abort(403);
        }

        return view('perfil.editar-espaco', compact('espaco'));
    }

    public function updateEspaco(Request $request, Espaco $espaco)
    {
        if ($espaco->user_id !== auth()->id()) {
            abort(403);
        }

        $request->validate([
            'nome' => 'required|string|max:255',
            'descricao' => 'required|string',
            'endereco' => 'required|string',
            'cidade' => 'required|string',
            'estado' => 'required|string',
            'cep' => 'required|string',
            'preco_hora' => 'required|numeric|min:0',
            'capacidade' => 'required|integer|min:1',
            'comodidades' => 'required|array|min:1',
            'imagem' => 'nullable|image|max:2048'
        ], [
            'comodidades.required' => 'Selecione pelo menos uma comodidade.',
            'comodidades.min' => 'Selecione pelo menos uma comodidade.'
        ]);

        $data = $request->all();
        
        if ($request->hasFile('imagem')) {
            $data['imagem'] = $request->file('imagem')->store('espacos', 'public');
        }

        $espaco->update($data);

        return redirect()->route('perfil')->with('success', 'Espaço atualizado com sucesso!');
    }

    public function deleteEspaco(Espaco $espaco)
    {
        if ($espaco->user_id !== auth()->id()) {
            abort(403);
        }

        $espaco->delete();
        return redirect()->route('perfil')->with('success', 'Espaço removido com sucesso!');
    }
}