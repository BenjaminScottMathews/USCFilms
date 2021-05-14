//
//  Debouncer.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/15/21.
//

import Foundation

public class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    public init(delay: TimeInterval)
    {
        self.delay = delay
    }

    /// Trigger the action after some delay
    public func run(action: @escaping () -> Void)
    {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
