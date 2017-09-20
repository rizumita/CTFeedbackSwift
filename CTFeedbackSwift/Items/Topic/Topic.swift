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
    case question  = "Question"
    case request   = "Request"
    case bugReport = "Bug Report"
    case other     = "Other"
}

extension Topic: TopicProtocol {
    var title:          String { return rawValue }
    var localizedTitle: String { return CTLocalizedString(title) }
}
