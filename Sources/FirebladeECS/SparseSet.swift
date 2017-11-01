//
//  SparseSet.swift
//  FirebladeECS
//
//  Created by Christian Treffs on 30.10.17.
//

public class SparseSet<Element>: UniformStorage, Sequence {
	public typealias Index = Int
	fileprivate typealias DenseIndex = Int
	fileprivate var size: Int = 0
	fileprivate var dense: ContiguousArray<Pair?>
	fileprivate var sparse: [Index: DenseIndex]
	fileprivate typealias Pair = (key: Index, value: Element)

	public init() {
		dense = ContiguousArray<Pair?>()
		sparse = [Index: DenseIndex]()
	}

	deinit {
		clear()
	}

	public var count: Int { return size }
	internal var capacitySparse: Int { return sparse.capacity }
	internal var capacityDense: Int { return dense.capacity }

	public func has(_ index: Index) -> Bool {
		return sparse[index] ?? Int.max < count &&
			dense[sparse[index]!] != nil
	}

	public func add(_ element: Element, at index: Index) {
		if has(index) { return }
		sparse[index] = count
		let entry: Pair = Pair(key: index, value: element)
		dense.append(entry)
		size += 1
	}

	public func get(at entityIdx: Index) -> Element? {
		guard has(entityIdx) else { return nil }
		return dense[sparse[entityIdx]!]!.value
	}

	public func remove(at index: Index) {
		guard has(index) else { return }
		let compIdx: DenseIndex = sparse[index]!
		let lastIdx: DenseIndex = count-1
		dense.swapAt(compIdx, lastIdx)
		sparse[index] = nil
		let swapped: Pair = dense[compIdx]!
		sparse[swapped.key] = compIdx
		_ = dense.popLast()!!
		size -= 1
		if size == 0 {
			clear(keepingCapacity: false)
		}
	}

	public func clear(keepingCapacity: Bool = false) {
		size = 0
		dense.removeAll(keepingCapacity: keepingCapacity)
		sparse.removeAll(keepingCapacity: keepingCapacity)
	}

	public func makeIterator() -> SparseIterator<Element> {
		return SparseIterator<Element>(self)
		/*
		// NOTE: was optimized by using a dedicated iterator implementation
		var iter = dense.makeIterator()
		return AnyIterator<Element>.init {
		guard let next: Pair = iter.next() as? Pair else { return nil }
		return next.value
		}*/
	}

	public struct SparseIterator<Element>: IteratorProtocol {
		private let sparseSet: SparseSet<Element>
		private var iterator: IndexingIterator<ContiguousArray<(key: Index, value: Element)?>>
		init(_ sparseSet: SparseSet<Element>) {
			self.sparseSet = sparseSet
			self.iterator = sparseSet.dense.makeIterator()
		}

		mutating public func next() -> Element? {
			guard let next: Pair = iterator.next() as? Pair else { return nil }
			return next.value as? Element
		}

	}
}

public class SparseComponentSet: SparseSet<Component> {
	public typealias Index = EntityIndex

}

public class SparseEntityIdentifierSet: SparseSet<EntityIdentifier> {
	public typealias Index = EntityIndex

}
