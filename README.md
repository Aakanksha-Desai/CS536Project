# CS536 Project
A mobile application that integrates with teh ChatGPT API to provide responses to user queries. This application incorporate speech recognition and text-to-speech technologies to enable users to engage with ChatGPT through voice commnads and receive spoken responses.

- Target devices: iPhone / iPad / Mac with M1/M2 (Designed for iPad)
- Target OS: iOS 16.0+, iPadOS 16.0+, macOS 13.0+
- Build system: Xcode 15.0.1
- SDK: SwiftUI, AVFoundation, Speech
- Swift Packages: OpenAISwift (OpenAI API Client Library in Swift)

## Features

- Users can input questions by voice.
- Users can get answers for the questions from ChatGPT, OpenAI's language AI.
- Users can listen answers by voice.
- Users can see their interaction history.


The code was initially developed by Yasuhito Nagatomo (https://github.com/ynagatomo/HeyChatGPT) and modified by us.

## Team Member
Aakanksha Desai - desai168@purdue.edu
Ellen Duan - duan99@purdue.edu
Peter Xu - xu1174@purdue.edu

## Build and Run the Project
### Get the OpenAI API Key

The API Key for OpenAI API is required.
You need to sign up to OpenAI site (https://openai.com/api/) and get the key at the account management page. (https://platform.openai.com/account/)
Then add the key to the file App/APIKey.swift.

```swift
// APIKey.swift
enum OpenAIAPIKey {
    static let key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```
