//
//  EventHandler.swift
//  PlayWatch
//
//  Created by David on 15/8/24.
//

protocol EventHandler {
    associatedtype Event
    @MainActor
    func on(_ event: Event) async
}
