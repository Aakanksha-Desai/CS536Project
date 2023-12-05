//
//  ContentView.swift
//  heychatgpt
//
//  Created by Yasuhito Nagatomo on 2023/02/18.
//  Modified by Ellen Duan on 2023/11/21.
//

import SwiftUI

extension Color {
    static func rgb(_ red: Double, _ green: Double, _ blue: Double, alpha: Double = 1.0) -> Color {
        return Color(.sRGB, red: red/255, green: green/255, blue: blue/255, opacity: alpha)
    }
}

struct ContentView: View {
    @StateObject var conversation = Conversation()
    @State private var showHistory = false
    private var canSpeak: Bool {
        (conversation.state == .idle) && !conversation.answer.isEmpty
    }
    private var canStartConversation: Bool { conversation.state == .idle }
    private var canStopConversation: Bool { conversation.state == .listening }
    private var canAsk: Bool { conversation.state != .asking }

    var body: some View {
        ZStack {
            Color("NewBGColor")

            VStack {
                HStack {
                    Spacer()
                    Text("Let's chat...")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                    Spacer()
                    Button(action: { showHistory.toggle() }, label: {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 30))
                            .foregroundColor(Color.rgb(102, 145, 102))
                    })
                    .padding(.bottom, 20)
                }
                

                // Message area
                ScrollView(showsIndicators: false) {

                    // Human' question
                    HStack {
                        Spacer()
                        Text(conversation.question)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("UserChatBGColor").cornerRadius(10))
//                            .frame(minWidth: 50, minHeight: 20)
                            .padding(.vertical, 4)
                        Image(systemName: "person")
                            .font(.system(size: 35))
                            .foregroundColor(Color.rgb(207, 104, 25))
                    }

                    // Answer from AI
                    HStack {
                        // Button to speak or to stop speaking
//                        Button(action: speak) {
//                            VStack {
//                                Image(systemName: "speaker.wave.2.bubble.left.fill")
//                                    .font(.system(size: 40))
//                                    .padding(.bottom, 4)
//                                Image(systemName: "tv")
//                                    .font(.system(size: 35))
//                                    .foregroundColor(Color.rgb(102, 145, 102))
//                            }.foregroundColor(canSpeak ? Color.rgb(67, 181, 67) : .gray)
//                        }
//                        .disabled(!canSpeak)

                        Image(systemName: "tv")
                            .font(.system(size: 35))
                            .foregroundColor(Color.rgb(102, 145, 102))
                        
                        Text(conversation.answer)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("BotChatBGColor").cornerRadius(10))
                            .padding(.vertical, 4)
                        Button(action: speak) {
                            Image(systemName: "speaker.wave.2.bubble.left.fill")
                                .font(.system(size: 30))
                                .padding(.bottom, 4).foregroundColor(canSpeak ? Color.rgb(67, 181, 67) : .gray)
                        }
                        .opacity(canSpeak ? 1 : 0)
                        .disabled(!canSpeak)
                        Spacer()
                    }
                }

                Spacer()

                // Prompt area
                if conversation.state != .listening {
                    // Button to start a conversation (Voice recognition will start.)
                    Button(action: startListening) {
                        HStack {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(canStartConversation ? Color.rgb(62, 107, 176) : Color.gray)
                                .clipShape(Circle())
                            Text("Click to start a conversation")
                                .padding(.leading, 8)
                                .foregroundColor(.black)
                        }
                    }
                    .disabled(!canStartConversation)
                } else {
                    HStack {
                        // Button to stop the conversation (Voice recognition will stop.)
                        Button(action: stopListening) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(Color.rgb(156, 78, 86))
                                .clipShape(Circle())
                        }
                        .disabled(!canStopConversation)

                        // A prompt recognized from human's voice
                        Text(conversation.prompt)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.cornerRadius(10))
                            .padding(.horizontal, 8)

                        Spacer()

                        // Button to ask ChatGPT about the prompt
                        Button(action: ask) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(canAsk ? Color.rgb(62, 107, 176) : Color.gray)
                                .clipShape(Circle())
                        }
                        .disabled(!canAsk)
                    }
                }
            }
            .padding()
            .onAppear {
                // Request an authorization for voice recognition
                SpeechRecognizer.shared.requestAuthorization()
            } // VStack
        } // ZStack
        .foregroundColor(.white)
        .sheet(isPresented: $showHistory) {
            HistoryView(talkLogs: conversation.talkLogs)
        }
    }

    // Speak the answer from ChatGPT or stop speaking when speaking
    private func speak() {
        conversation.speak()
    }

    // Ask ChatGPT about the prompt(question)
    private func ask() {
        Task {
            await conversation.ask()
        }
    }

    // Start listening (will start voice recognition)
    private func startListening() {
        conversation.startListening()
    }

    // Stop listening (will stop voice recognition)
    private func stopListening() {
        conversation.stopListening()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
