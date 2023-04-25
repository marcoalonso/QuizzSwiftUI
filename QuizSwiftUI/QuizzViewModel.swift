//
//  QuizzViewModel.swift
//  QuizSwiftUI
//
//  Created by Marco Alonso Rodriguez on 24/04/23.
//

import Foundation
import AVFoundation

class QuizVieModel: ObservableObject {
    @Published var preguntas = [
        Pregunta(texto: "Tokio siempre ha sido la capital de Japón.", respuesta: "FALSO", imagen: "tokio"),
        Pregunta(texto: "Los nativos americanos enterraban sus hachas cuando hacían las pases.", respuesta: "VERDADERO", imagen: "nativos"),
        Pregunta(texto: "El aluminio fue una vez más valioso que el oro.", respuesta: "VERDADERO", imagen: "oro"),
        Pregunta(texto: "El papel de aluminio amplifica el Wifi.", respuesta: "VERDADERO", imagen: "aluminio"),
        Pregunta(texto: "Google inicialmente se llamaba BackRub.", respuesta: "VERDADERO", imagen: "google"),
        Pregunta(texto: "El cráneo es el hueso más fuerte del cuerpo humano.", respuesta: "FALSO", imagen: "craneo"),
        Pregunta(texto: "La Coca Cola esta disponible en todos los países del mundo.", respuesta: "FALSO", imagen: "coca"),
        
    ]
    
    @Published var numeroPregunta = 0
    @Published var puntuacion = 0
    
    var reproductor: AVAudioPlayer?
    
    func revisarRespuestaUser(respuesta: String) -> Bool {
        if respuesta == preguntas[numeroPregunta].respuesta {
            puntuacion += 1
            return true
        } else {
            return false
        }
    }
    
    func obtenerPuntuacion() -> Int {
        return puntuacion
    }
    
    func obtenerTextoPregunta() -> String {
        return preguntas[numeroPregunta].texto
    }
    
    func obtenerProgreso() -> Float {
        let progreso = Float(numeroPregunta + 1) / Float(preguntas.count)
        return progreso
    }
    
    func obtenerImagen() -> String {
        return preguntas[numeroPregunta].imagen
    }
    
    func siguientePregunta() -> Bool {
        if numeroPregunta + 1 < preguntas.count {
            return true
        } else {
            return false
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "mp3") else {
            return
        }
        do {
            reproductor = try AVAudioPlayer(contentsOf: url)
            reproductor?.play() //si hay un reproductor, ejecuta el metod play
        } catch {
            print("Error al reproducir sonido, \(error.localizedDescription)")
        }
    }
}
