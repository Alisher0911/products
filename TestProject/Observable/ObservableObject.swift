//
//  ObservableObject.swift
//  TestProject
//
//  Created by Alisher Orazbay on 10.11.2022.
//

import Foundation

final class ObservableObject<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T) -> Void) {
        listener(value )
        self.listener = listener
    }
}
