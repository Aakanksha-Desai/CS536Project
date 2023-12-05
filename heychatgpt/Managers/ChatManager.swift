//
//  ChatManager.swift
//  heychatgpt
//
//  Created by Yasuhito Nagatomo on 2023/02/18.
//  Modified by Ellen Duan on 2023/11/23.

//import OpenAISwift
import OpenAI
import Foundation

final class APICacheManager {
    static let shared = APICacheManager()
    
    private init() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Save response to cache
    func cacheResponse(response: String, forRequest requestKey: String) {
        UserDefaults.standard.set(response, forKey: requestKey)
    }
    
    // Retrieve cached response for a given request
    func getCachedResponse(forRequest requestKey: String) -> String? {
        return UserDefaults.standard.string(forKey: requestKey)
    }
}

final class ChatManager {
    static let shared = ChatManager()
    
    private let openAIAPIKey = OpenAIAPIKey.key
    private let openAIAPIURL = URL(string: "https://api.openai.com/v1/engines/davinci/completions")!
    private let cacheManager = APICacheManager.shared

    
    private let openAIServices: OpenAI = OpenAI(apiToken: OpenAIAPIKey.key)

    private init() {}
    
    func sendText(_ text: String) async -> String {
        // Check if the response is cached
        if let cachedResponse = cacheManager.getCachedResponse(forRequest: text) {
            print("Cached response!!")
            return cachedResponse
        }

        var response = ""
        do {
            // Perform API request
            let result = try await performRequest(with: text, maxTokens: 300)
            response = result.choices.first?.text ?? "oops"

            // Cache the response
            cacheManager.cacheResponse(response: response, forRequest: text)
        } catch {
            var count = 0
            while response.contains("network connection was lost") && count < 3 {
                sleep(1)
                do {
                    print("retry")
                    let query = CompletionsQuery(model: .textDavinci_003, prompt: text, temperature: 0, maxTokens: 1000, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
                    let result = try await openAIServices.completions(query: query)
                    response = result.choices.first?.text ?? "oops"
                } catch {
                    response = error.localizedDescription
                }
                count += 1
            }
        }
        
        return response
    }
    
    private func performRequest(with text: String, maxTokens: Int) async throws -> CompletionsResult {
        let query = CompletionsQuery(model: .textDavinci_003, prompt: text, temperature: 0, maxTokens: 1000, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        let result = try await openAIServices.completions(query: query)
        return result
    }
}
