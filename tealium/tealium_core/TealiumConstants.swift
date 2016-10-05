//
//  TealiumConstants.swift
//  tealium-swift
//
//  Created by Jason Koo on 9/1/16.
//  Copyright © 2016 tealium. All rights reserved.
//

enum TealiumKey {
    static let account = "tealium_account"
    static let profile = "tealium_profile"
    static let environment = "tealium_environment"
    static let eventName = "event_name"                             // deprecating
    static let event = "tealium_event"
    static let eventType = "tealium_event_type"
    static let legacyVid = "tealium_vid"                            // deprecating
    static let libraryName = "tealium_library_name"
    static let libraryVersion = "tealium_library_version"
    static let overrideCollectUrl = "tealium_override_collect_url"
    static let random = "tealium_random"
    static let sessionId = "tealium_session_id"
    static let timestampEpoch = "tealium_timestamp_epoch"
    static let visitorId = "tealium_visitor_id"
}

enum TealiumModuleConfigKey {
    static let all = "com.tealium.module.configs"
    static let enable = "config_enable"
    static let name = "config_name"
    static let className = "config_class_name"
    static let priority = "config_priority"
}

enum TealiumValue {
    static let libraryName = "swift"
    static let libraryVersion = "1.1.0"
}

enum TealiumTrackType {
    case view           // Whenever content is displayed to the user.
    case activity       // Behavioral actions by the user such as a cart actions, or any other application-specific event.
    case interaction    // Interaction between user and an external resource (ie other people). Usually offline activities such as a booth visit or phone call, but can be text sent to an online chat agent.
    case derived        // Inferred user data or somehow provided without direct action by user, such as demographics, predictive data, campaign value relations, etc.
    case conversion     // Desired goal has been reached.
    
    func description() -> String {
        switch self {
        case .view:
            return "view"
        case .interaction:
            return "interaction"
        case .derived:
            return "derived"
        case .conversion:
            return "conversion"
        default:
            return "activity"
        }
    }
    
}


