//
//  APIClient.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//
import Foundation

// MARK: - Event Errors
enum EventError: Error, LocalizedError {
    case invalidURL
    case noInternetorTimeout
    case serverError(statusCode: Int)
    case decodeError
    case unknown(Error)
    /// User-friendly messages perfectly suited for a Toast or Alert UI
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Internal error: The server address was configured incorrectly."
        case .noInternetorTimeout:
            return "Connection lost. Please check your internet and try again."
        case .serverError(let statusCode):
            return "The server responded with an error (Code: \(statusCode)). Please try again later."
        case .decodeError:
            return "We encountered an issue reading the data. Please ensure your app is updated."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

/// A fully generic data parser capable of processing any Codable types.
struct JSONDataParser: Sendable {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init() {
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    /// Decodes raw data into any specified type conforming to Decodable.
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw EventError.decodeError
        }
    }
    /// Encodes any specified type conforming to Encodable into raw data.
    func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw EventError.decodeError
        }
    }
}

final class APIClient: Sendable {
    private let parser: JSONDataParser
    init(parser: JSONDataParser = JSONDataParser()) {
        self.parser = parser
    }
    /// Fetches data from a given string URL and returns the decoded model type.
    func fetch<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw EventError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw EventError.unknown(URLError(.badServerResponse))
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw EventError.serverError(statusCode: httpResponse.statusCode)
            }
            // Decode dynamically into the requested type
            guard let url = Bundle.main.url(forResource: "eventList", withExtension: "json") else {
                throw URLError(.fileDoesNotExist)
            }
            let data2 = try Data(contentsOf: url)
           let result =   try JSONDecoder().decode([Event].self, from: data2)
           // print(result.count)
            return try parser.decode(T.self, from: data2)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                throw EventError.noInternetorTimeout
            default:
                throw EventError.unknown(error)
            }
        } catch let error as EventError {
            throw error
        } catch {
            throw EventError.unknown(error)
        }
    }
}
