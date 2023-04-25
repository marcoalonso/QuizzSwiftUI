//
//  Pregunta.swift
//  QuizSwiftUI
//
//  Created by Marco Alonso Rodriguez on 24/04/23.
//

import Foundation

struct Pregunta: Identifiable {
    let id = UUID()
    let texto: String
    let respuesta: String
    let imagen: String
}


