//
//  TableViewController.swift
//  Changeset
//

import UIKit
import Changeset

class TableViewController: UITableViewController {
	
	fileprivate var dataSource = DataSource()

    @IBOutlet weak var testButtonItem: UIBarButtonItem!
    @IBOutlet weak var hierarchicalTestButtonItem: UIBarButtonItem!
	
	@IBAction func test(_ sender: UIBarButtonItem) {
		self.dataSource.runTests() { (edits: Array<Changeset<String>.Edit>, isComplete: Bool) in
			self.tableView.update(with: edits)
			self.testButtonItem.isEnabled = isComplete
            self.hierarchicalTestButtonItem.isEnabled = isComplete
		}
	}

    @IBAction func hierarchicalTest(_ sender: Any) {
        self.dataSource.runTests { (edits: Array<Changeset<[String]>.Edit>, isComplete) in
            self.tableView.update(with: edits)
            self.testButtonItem.isEnabled = isComplete
            self.hierarchicalTestButtonItem.isEnabled = isComplete
        }
    }
	
	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSource.numberOfSections
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.numberOfElementsInSection(section)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = self.dataSource.textForElementAtIndexPath(indexPath)
		return cell
	}
}
