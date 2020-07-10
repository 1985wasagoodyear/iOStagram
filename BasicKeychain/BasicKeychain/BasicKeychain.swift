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
    
    public let name: String
    private let item: KeychainPasswordItem
    
    // MARK: - Init
    
    public init(name: String, service: String, accessGroup: String? = nil) {
        self.name = name
        let defaults = BasicKeychainDefaults()
        if defaults.checkSecurityFirstUseFlag(service: service) == true {
            try? BasicKeychain.deleteAll(service: service)
        }
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
    
    class func deleteAll(service: String) throws {
        try KeychainPasswordItem
            .passwordItems(forService: service)
            .forEach {
                try $0.deleteItem()
            }
    }
    
}
