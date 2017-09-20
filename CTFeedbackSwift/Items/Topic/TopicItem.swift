//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct TopicItem {
    var title:      String? { return CTLocalizedString("CTFeedback.Topic") }
    var topicTitle: String { return selected?.localizedTitle ?? topics.first?.localizedTitle ?? "" }
    var topics:     [TopicProtocol] = []
    var selected:   TopicProtocol? {
        get { return _selected ?? topics.first }
        set { _selected = newValue }
    }
    private var _selected: TopicProtocol?
}
