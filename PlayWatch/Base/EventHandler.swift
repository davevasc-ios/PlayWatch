//
//  EventHandler.swift
//  PlayWatch
//
//  Created by David on 15/8/24.
//

protocol EventHandler {
    associatedtype Event
    func on(_ event: Event)
}
