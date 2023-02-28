//
//  Component.swift
//  FirebladeECS
//
//  Created by Christian Treffs on 08.10.17.
//

/// **Component**
///
/// A component represents the raw data for one aspect of an entity.
public protocol Component: AnyObject {
    /// Unique, immutable identifier of this component type.
    static var identifier: ComponentIdentifier { get }

    /// Unique, immutable identifier of this component type.
    var identifier: ComponentIdentifier { get }
}

extension Component {
    public static var identifier: ComponentIdentifier { ComponentIdentifier(self) }
    @inline(__always)
    public var identifier: ComponentIdentifier { type(of: self).identifier }
}
