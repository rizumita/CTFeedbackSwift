//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public protocol TopicProtocol {
    var title:          String { get }
    var localizedTitle: String { get }
}

enum Topic: String {
    case question  = "CTFeedback.Question"
    case request   = "CTFeedback.Request"
    case bugReport = "CTFeedback.BugReport"
    case other     = "CTFeedback.Other"
}

extension Topic: TopicProtocol {
    var title:          String { return rawValue }
    var localizedTitle: String { return CTLocalizedString(title) }
}
