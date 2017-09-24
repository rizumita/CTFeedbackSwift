//
// Created by 和泉田 領一 on 2017/09/09.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public protocol FeedbackEditingItemsRepositoryProtocol {
    func item<Item>(of type: Item.Type) -> Item?

    @discardableResult
    func set<Item:FeedbackItemProtocol>(item: Item) -> IndexPath?
}
