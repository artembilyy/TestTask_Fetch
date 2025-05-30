//
//  HTTPClient.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

// MARK: - HTTPClient
public protocol HTTPClient: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T
    func requestData(_ endpoint: APIEndpoint) async throws -> Data
}

// MARK: - APIEndpoint
public struct APIEndpoint: Sendable {
    public let url: URL
    public let method: HTTPMethod
    public let headers: [String: String]
    public let timeoutInterval: TimeInterval

    public init(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.timeoutInterval = timeoutInterval
    }
}

// MARK: - HTTPMethod
public enum HTTPMethod: String, Sendable {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

// MARK: - HTTPError
public enum HTTPError: Error, Sendable {
    case invalidURL
    case noData
    case invalidResponse
    case statusCode(Int, Data?)
    case networkError(Error)
    case decodingError(Error)
    case timeout

    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .noData:
            "No data received"
        case .invalidResponse:
            "Invalid response"
        case .statusCode(let code, _):
            "HTTP error: \(code)"
        case .networkError(let error):
            "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            "Decoding error: \(error.localizedDescription)"
        case .timeout:
            "Request timeout"
        }
    }
}

// MARK: - URLSessionHTTPClient
public actor URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.jsonDecoder = jsonDecoder
    }

    public func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let data = try await requestData(endpoint)

        do {
            return try jsonDecoder.decode(T.self, from: data)

        } catch {
            throw HTTPError.decodingError(error)
        }
    }

    public func requestData(_ endpoint: APIEndpoint) async throws -> Data {
        let request = try buildURLRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200 ... 299:
                return data
            case 400 ... 499:
                throw HTTPError.statusCode(httpResponse.statusCode, data)
            case 500 ... 599:
                throw HTTPError.statusCode(httpResponse.statusCode, data)
            default:
                throw HTTPError.statusCode(httpResponse.statusCode, data)
            }

        } catch let error as HTTPError {
            throw error
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    throw HTTPError.timeout
                case .networkConnectionLost, .notConnectedToInternet:
                    throw HTTPError.networkError(urlError)
                default:
                    throw HTTPError.networkError(urlError)
                }
            }
            throw HTTPError.networkError(error)
        }
    }

    private func buildURLRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeoutInterval

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
