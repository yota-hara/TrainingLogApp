//
//  BehaviorRelay-Extensions.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/14.
//

import RxSwift
import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(model: Element.Element) {
        var array = self.value
        array.append(model)
        self.accept(array)
    }
    
    func update(model: Element.Element, index: Element.Index) {
            var array = self.value
            array.remove(at: index)
            array.insert(model, at: index)
            self.accept(array)
        }
    
    func insert(model: Element.Element, index: Element.Index) {
            var array = self.value
            array.insert(model, at: index)
            self.accept(array)
        }
    
    func remove(index: Element.Index) {
            var array = self.value
            array.remove(at: index)
            self.accept(array)
        }
}
