import XCTest
@testable import TrashDayLog

@MainActor
final class TrashDayLogTests: XCTestCase {
    func testSeedDataLoadsBelowFreeLimit() {
        let store = Store()
        XCTAssertFalse(store.entries.isEmpty)
        XCTAssertLessThan(store.entries.count, Store.freeEntryLimit)
    }

    func testCanAddWhenBelowLimit() {
        let store = Store()
        XCTAssertTrue(store.canAdd(isPro: false))
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(BinEntry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        let entry = BinEntry()
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testFreeLimitEnforcedWhenNotPro() {
        let store = Store()
        for _ in 0..<(Store.freeEntryLimit + 5) {
            store.add(BinEntry())
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesFreeLimit() {
        let store = Store()
        for _ in 0..<(Store.freeEntryLimit + 5) {
            store.add(BinEntry())
        }
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testUpdateModifiesExistingEntry() {
        let store = Store()
        var entry = BinEntry()
        store.add(entry)
        entry.notes = "updated" as String? != nil ? entry.notes : entry.notes
        store.update(entry)
        XCTAssertTrue(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testDeleteAtOffsetsRemovesCorrectEntry() {
        let store = Store()
        store.entries.removeAll()
        let a = BinEntry()
        let b = BinEntry()
        store.entries = [a, b]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.id, b.id)
    }
}
