<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class UploadController extends Controller
{
    public function uploadImage(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:5120', // 5MB
        ]);

        try {
            $image = $request->file('image');
            $filename = time() . '_' . Str::uuid() . '.' . $image->getClientOriginalExtension();
            
            $path = $image->storeAs('espacos', $filename, 'public');
            
            return response()->json([
                'success' => true,
                'path' => $path,
                'url' => '/storage/' . $path,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro ao fazer upload da imagem',
            ], 500);
        }
    }

    public function deleteImage(Request $request)
    {
        $request->validate([
            'path' => 'required|string',
        ]);

        try {
            if (Storage::disk('public')->exists($request->path)) {
                Storage::disk('public')->delete($request->path);
            }

            return response()->json([
                'success' => true,
                'message' => 'Imagem removida com sucesso',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro ao remover imagem',
            ], 500);
        }
    }
}