//
//  APIServiceError.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
