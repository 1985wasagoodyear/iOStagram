//
//  BasicKeychain.swift
//  Created 6/29/20
//  Using Swift 5.0
//
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

/// Basic wrapper around Keychain, from Apple's `GenericKeychain` sample source.
open class BasicKeychain {
    
    // MARK: - Properties
    
    public static var wipeKeychainOnStart: Bool = true
    
    public let name: String
    private let item: KeychainPasswordItem
    
    // MARK: - Init
    
    // TODO: -  annotate what 'name', 'service', and 'accessGroup' mean
    public init(name: String, service: String, accessGroup: String? = nil) {
        self.name = name
        try? BasicKeychain.clearItemsIfNeeded(for: service)
        item = KeychainPasswordItem(service: service,
                                    account: name,
                                    accessGroup: accessGroup)
    }
    
    // MARK: - Accessors
    
    open func set(_ value: String) throws {
        try item.savePassword(value)
    }
    
    open func get() throws -> String? {
        try item.readPassword()
    }
    
    open func delete() throws {
        try item.deleteItem()
    }
    
    // MARK: - Class Accessor
    
    class open func deleteAll(service: String) throws {
        try KeychainPasswordItem
            .passwordItems(forService: service)
            .forEach {
                try $0.deleteItem()
            }
    }
    
    /// clears Keychain if this is a fresh install of the app
    class open func clearItemsIfNeeded(for service: String) throws {
        guard BasicKeychain.wipeKeychainOnStart == true else { return }
        let defaults = BasicKeychainDefaults()
        if defaults.checkSecurityFirstUseFlag(service: service) == true {
            try BasicKeychain.deleteAll(service: service)
        }
    }
    
}
