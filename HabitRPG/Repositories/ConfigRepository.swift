//
//  RemoteConfigRepository.swift
//  Habitica
//
//  Created by Phillip Thelen on 16/03/2017.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//
import Foundation
import Habitica_API_Client
import FirebaseRemoteConfig

@objc
enum ConfigVariable: Int {
    case supportEmail
    case shopSpriteSuffix
    case maxChatLength
    case enableGiftOneGetOne
    case enableUsernameAutocomplete
    case spriteSubstitutions

    func name() -> String {
        // swiftlint:disable switch_case_on_newline
        switch self {
        case .supportEmail: return "supportEmail"
        case .shopSpriteSuffix: return "shopSpriteSuffix"
        case .maxChatLength: return "maxChatLength"
        case .enableGiftOneGetOne: return "enableGiftOneGetOne"
        case .enableUsernameAutocomplete: return "enableUsernameAutocomplete"
        case .spriteSubstitutions: return "spriteSubstitutions"
        }
        // swiftlint:enable switch_case_on_newline
    }
    
    func defaultValue() -> NSObject {
        switch self {
        case .supportEmail: return NSString(string: "admin@habitica.com")
        case .shopSpriteSuffix: return NSString(string: "")
        case .maxChatLength: return NSNumber(integerLiteral: 3000)
        case .enableGiftOneGetOne: return NSNumber(booleanLiteral: false)
        case .enableUsernameAutocomplete: return NSNumber(booleanLiteral: false)
        case .spriteSubstitutions: return NSDictionary()
        }
    }
    
    static func allVariables() -> [ConfigVariable] {
        return [
            .supportEmail,
            .shopSpriteSuffix,
            .maxChatLength,
            .enableGiftOneGetOne,
            .enableUsernameAutocomplete,
            .spriteSubstitutions
        ]
    }
}

@objc
class ConfigRepository: NSObject {

    private static let remoteConfig = RemoteConfig.remoteConfig()
    private let userConfig = UserDefaults.standard

    @objc
    func fetchremoteConfig() {
        ConfigRepository.remoteConfig.fetch(withExpirationDuration: HabiticaAppDelegate.isRunningLive() ? 3600 : 0) { (status, error) in
            ConfigRepository.remoteConfig.activateFetched()
        }
        var defaults = [String: NSObject]()
        for variable in ConfigVariable.allVariables() {
            defaults[variable.name()] = variable.defaultValue()
        }
        ConfigRepository.remoteConfig.setDefaults(defaults)
    }

    @objc
    func bool(variable: ConfigVariable) -> Bool {
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).boolValue
    }

    @objc
    func string(variable: ConfigVariable) -> String? {
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).stringValue
    }
    @objc
    func string(variable: ConfigVariable, defaultValue: String) -> String {
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).stringValue ?? defaultValue
    }
    
    @objc
    func integer(variable: ConfigVariable) -> Int {
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).numberValue?.intValue ?? 0
    }
}
