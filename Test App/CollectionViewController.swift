//
//  CollectionViewController.swift
//  Changeset
//

import UIKit
import Changeset

class CollectionViewController: UICollectionViewController {
	
	fileprivate var dataSource = DataSource()

    @IBOutlet weak var testButtonItem: UIBarButtonItem!
    @IBOutlet weak var hierarchicalTestButtonItem: UIBarButtonItem!
	
	@IBAction func test(_ sender: UIBarButtonItem) {
		self.dataSource.runTests() { (edits: Array<Changeset<String>.Edit>, isComplete: Bool) in
			self.collectionView?.update(with: edits)
            self.testButtonItem.isEnabled = isComplete
            self.hierarchicalTestButtonItem.isEnabled = isComplete
		}
	}

    @IBAction func hierarchicalTest(_ sender: Any) {
        self.dataSource.runTests { (edits: Array<Changeset<[String]>.Edit>, isComplete) in
            self.collectionView?.update(with: edits)
            self.testButtonItem.isEnabled = isComplete
            self.hierarchicalTestButtonItem.isEnabled = isComplete
        }
    }

	// MARK: - UICollectionViewDataSource

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.dataSource.numberOfSections
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dataSource.numberOfElementsInSection(section)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
		cell.label.text = self.dataSource.textForElementAtIndexPath(indexPath)
		return cell
	}
}
