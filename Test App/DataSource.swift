//
//  DataSource.swift
//  Changeset
//

import UIKit
import Changeset

private let kDefaultData = "changeset"
private let kTestData = [
	"64927513",
	"917546832",
	"8C9A2574361B",
	"897A34B215C6",
	"5198427",
	"768952413",
	kDefaultData,
]
private let kDefaultHierarchicalData = ["123", "ab"]
private let kTestHierarchicalData = [
	["123", "abc"],
	["123", "abd"],
	["123", "abe"],
	["abe", "123"],
	["123", "abe"],
	["123", "ab"],
	["123", "a"],
	["123"],
	["12"],
	["1"],
	[],
	["123", "ab"],
]
private let kTestInterval: TimeInterval = 0.5

class DataSource {
	
	fileprivate var data = kDefaultData

	fileprivate var hierarchicalData: [String]? = kDefaultHierarchicalData
	
	/// The callback is called after each test to let the caller update its view, or whatever.
	func runTests(_ testData: Array<String> = kTestData, callback: @escaping ((_ edits: Array<Changeset<String>.Edit>, _ isComplete: Bool) -> Void)) {
		var nextTestData = testData
		let next = nextTestData.remove(at: 0)
		let edits = Changeset.edits(from: self.data, to: next) // Call naiveEditDistance for a different approach
		
		self.data = next
		callback(edits, nextTestData.isEmpty)
		
		guard !nextTestData.isEmpty else { return }
		
		// Schedule next test.
		let when = DispatchTime.now() + kTestInterval
		DispatchQueue.main.asyncAfter(deadline: when) {
			self.runTests(nextTestData, callback: callback)
		}
	}

	func runTests(_ testData: Array<Array<String>> = kTestHierarchicalData, callback: @escaping ((_ edits: Array<Changeset<[String]>.Edit>, _ isComplete: Bool) -> Void)) {
		var nextTestData = testData
		let next = nextTestData.remove(at: 0)
		let edits = Changeset.edits(from: self.hierarchicalData!, to: next) // Call naiveEditDistance for a different approach

		self.hierarchicalData = next
		callback(edits, nextTestData.isEmpty)

		guard !nextTestData.isEmpty else { return }

		// Schedule next test.
		let when = DispatchTime.now() + kTestInterval
		DispatchQueue.main.asyncAfter(deadline: when) {
			self.runTests(nextTestData, callback: callback)
		}
	}
	
	// MARK: -

	var numberOfSections: Int {
		guard let hierarchicalData = hierarchicalData else {
			return 1
		}
		return hierarchicalData.count
	}
	
	func numberOfElementsInSection(_ section: Int) -> Int {
		guard let hierarchicalData = hierarchicalData else {
			return self.data.count
		}
		return hierarchicalData[section].count
	}
	
	func textForElementAtIndexPath(_ indexPath: IndexPath) -> String {
		let data = hierarchicalData?[indexPath.section] ?? self.data
		return String(data[data.index(data.startIndex, offsetBy: indexPath.row)])
	}
}
