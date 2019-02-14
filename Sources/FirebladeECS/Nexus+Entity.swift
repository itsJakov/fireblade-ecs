//
//  Nexus+Entity.swift
//  FirebladeECS
//
//  Created by Christian Treffs on 13.10.17.
//

extension Nexus {
	private func nextEntityIdx() -> EntityIndex {
		guard let nextReused: EntityIdentifier = freeEntities.popLast() else {
			return entityStorage.count
		}
		return nextReused.index
	}

    // swiftlint:disable function_default_parameter_at_end
	@discardableResult
    public func create(entity name: String? = nil, with assignedComponents: Component...) -> Entity {
		let newEntityIndex: EntityIndex = nextEntityIdx()
		let newEntityIdentifier: EntityIdentifier = newEntityIndex.identifier
        let newEntity = Entity(nexus: self, id: newEntityIdentifier, name: name)
		entityStorage.insert(newEntity, at: newEntityIndex)
		notify(EntityCreated(entityId: newEntityIdentifier))
        assignedComponents.forEach { newEntity.assign($0) }
        return newEntity
    }
    // swiftlint:enable function_default_parameter_at_end

	/// Number of entities in nexus.
	public var numEntities: Int {
		return entityStorage.count
	}

	public func exists(entity entityId: EntityIdentifier) -> Bool {
		return entityStorage.contains(entityId.index)
	}

	public func get(entity entityId: EntityIdentifier) -> Entity? {
		return entityStorage.get(at: entityId.index)
	}

    public func get(unsafeEntity entityId: EntityIdentifier) -> Entity {
        return entityStorage.get(unsafeAt: entityId.index)
    }

	@discardableResult
	public func destroy(entity: Entity) -> Bool {
		let entityId: EntityIdentifier = entity.identifier
		let entityIdx: EntityIndex = entityId.index

		guard entityStorage.remove(at: entityIdx) != nil else {
			report("EntityRemove failure: no entity \(entityId) to remove")
			return false
		}

        if clear(componentes: entityId) {
            update(familyMembership: entityId)
        }

        freeEntities.append(entityId)

		notify(EntityDestroyed(entityId: entityId))
		return true
	}
}
