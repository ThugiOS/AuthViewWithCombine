//
//  ContentView.swift
//  AuthViewWithCombine
//
//  Created by Никитин Артем on 7.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    private let screen = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color.dark
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35.0) {
                    
                    Image("Boy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screen / 1.25, height: screen / 1.25)
                    
                    
                    Text("Authorization")
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .padding(8)
                    
                    VStack(spacing: 20) {
                        CustomTextField(title: "Email", text: $viewModel.email, prompt: viewModel.emailPrompt)
                        CustomTextField(title: "Phone", text: $viewModel.phone, prompt: viewModel.phonePrompt)
                            .onChange(of: viewModel.phone) { _ in
                                DispatchQueue.main.async {
                                    viewModel.phone = viewModel.phone.formattedMask(text: viewModel.phone, mask: "+XXX (XX) XXX-XX-XX")
                                }
                            }
                            .keyboardType(.decimalPad)
                        CustomTextField(title: "Password", text: $viewModel.password, prompt: viewModel.passwordPrompt , isSecure: true)
                    }
                    .padding(.horizontal)
                    
                    Button {} label: {
                        ZStack {
                            if viewModel.canSubmit {
                                AnimatedGradient(colors: [.purple, .cyan])
                            } else {
                                Rectangle()
                                    .foregroundColor(.gray)
                            }
                            Text("Login")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                        }
                        .cornerRadius(12)
                        .frame(width: 150.0, height: 44.0)
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
