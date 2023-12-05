//
//  HistoryView.swift
//  heychatgpt
//
//  Created by Yasuhito Nagatomo on 2023/02/19.
//  Modified by Ellen Duan on 2023/11/21.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    let talkLogs: [Conversation.Dialog]

    var body: some View {
        ZStack {
            Color("HomeBGColor").opacity(0.8)

            VStack {
                HStack {
                    Spacer()
                    Text("Conversation History").font(.title2).foregroundColor(.white)
                    Spacer()
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 40))
                            .foregroundColor(Color.rgb(230, 50, 37))
                    }
                }
                ScrollView {
                    ForEach(talkLogs) { log in
                        HStack {
                            Spacer()
                            Text(log.question)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("UserChatBGColor").cornerRadius(10))
                                .padding(.vertical, 4)
                            Image(systemName: "person")
                                .font(.system(size: 35))
                                .foregroundColor(Color.rgb(252, 134, 43))
                        }
                        HStack {
                            Image(systemName: "tv")
                                .font(.system(size: 35))
                                .foregroundColor(Color.rgb(95, 199, 95))
                            Text(log.answer)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("BotChatBGColor").cornerRadius(10))
                                .padding(.vertical, 4)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static let talkLogs: [Conversation.Dialog] = [
        Conversation.Dialog(question: "My first question.", answer: "AI's answer."),
        Conversation.Dialog(question: "My 2nd question.", answer: "AI's answer.")
    ]
    static var previews: some View {
        HistoryView(talkLogs: talkLogs)
    }
}
