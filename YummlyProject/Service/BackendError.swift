//
//  BackendError.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 22/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
