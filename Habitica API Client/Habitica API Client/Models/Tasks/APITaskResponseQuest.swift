//
//  APITaskResponseQuest.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class APITaskResponseQuest: TaskResponseQuestProtocol, Decodable {
    var progressDelta: Float = 0
}
