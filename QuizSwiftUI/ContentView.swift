//
//  ContentView.swift
//  QuizSwiftUI
//
//  Created by Marco Alonso Rodriguez on 24/04/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = QuizVieModel()
    @State private var progressValue: Float = 0.0
    @State var colorButtonVerdadero = 0
    @State var colorButtonFalso = 0
    @State private var mostrarAlerta = false
    @State private var areButtonsDisabled = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Puntaje: \(viewModel.puntuacion) pts")
                    .font(.title)
                
                Image(viewModel.preguntas[viewModel.numeroPregunta].imagen)
                    .resizable()
                    .cornerRadius(15)
                    .shadow(radius: 8)
                
                Text(viewModel.preguntas[viewModel.numeroPregunta].texto)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxHeight: 220)
                
                VStack {
                    Button {
                        revisarRespuesta(true, respuesta: "VERDADERO")
                        
                        
                    } label: {
                        Text("VERDADERO")
                            .font(.title2)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                            .background(
                                colorButtonVerdadero == 0 ? .white :
                                    colorButtonVerdadero == 1 ? .green :
                                        .red
                            )
                            .cornerRadius(25)
                    }
                    .disabled(areButtonsDisabled)
                    
                    Button {
                        revisarRespuesta(false, respuesta: "FALSO")
                    } label: {
                        Text("FALSO")
                            .font(.title2)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                            .background(
                                colorButtonFalso == 0 ? .white :
                                    colorButtonFalso == 1 ? .green :
                                        .red
                            )
                            .cornerRadius(25)
                    }
                    .disabled(areButtonsDisabled)
                    
                }
                
                ProgressView(value: progressValue)
                    .progressViewStyle(LinearProgressViewStyle())
                    .foregroundColor(.white)
                    .background(.black)
                    .scaleEffect(1.0)
                    .padding()
                
                
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .alert(isPresented: $mostrarAlerta, content: {
                Alert(
                    title: Text("¡Fin del Quizz!"),
                    message: Text("Tu puntuación es de: \(viewModel.puntuacion)"),
                    primaryButton: .default(Text("Reiniciar")) {
                        viewModel.numeroPregunta = 0
                        viewModel.puntuacion = 0
                        colorButtonFalso = 0
                        colorButtonVerdadero = 0
                        progressValue = 0.0
                        areButtonsDisabled = false
                    },
                    secondaryButton: .default(Text("Salir")) {
                        exit(0)
                    }
                )
            })
        }
    }
    
    func revisarRespuesta(_ verdaderoButton: Bool , respuesta: String){
        areButtonsDisabled = true
        let respuestaCorrecta = viewModel.revisarRespuestaUser(respuesta: respuesta)
        if respuestaCorrecta {
            viewModel.playSound()
            print("Correcta :D ")
            if verdaderoButton {
                colorButtonVerdadero = 1
            } else {
                colorButtonFalso = 1
            }
            
        } else {
            print("Incorrecta :/")
            
            //Vibracion
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            if verdaderoButton {
                colorButtonVerdadero = 2
            } else {
                colorButtonFalso = 2
            }
        }
        
        
        ///AVANZAR A LA SIGUIENTE PREGUNTA
        if viewModel.siguientePregunta() {
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                viewModel.numeroPregunta += 1
            print("Cambiar pregunta")
                colorButtonFalso = 0
                colorButtonVerdadero = 0
                areButtonsDisabled = false
                progressValue = viewModel.obtenerProgreso()
            }
        } else {
            mostrarAlerta = true
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
