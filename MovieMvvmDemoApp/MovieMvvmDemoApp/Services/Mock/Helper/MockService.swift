//
//  MockService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 30/09/25.
//

import Foundation

class MockService {
    private func fileData(forResource resource: String) throws -> Data {
        let filePath = Bundle.main.path(forResource: resource, ofType: "json") ?? ""
        let url: URL = URL(filePath: filePath)
        return try Data(contentsOf: url)
    }
    
    public func decodableObject<T: Decodable>(forResource resource: String, type: T.Type) throws -> T {
        let data = try fileData(forResource: resource)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
