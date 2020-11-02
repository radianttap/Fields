import UIKit

final class SlideTestController: FieldsCollectionController {
	
	var dataSource: SlideTestDataSource? {
		didSet {
			if !isViewLoaded { return }
			
			prepare(dataSource)
			render(dataSource)
		}
	}
	
	//	MARK:- View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		prepare(dataSource)
		render(dataSource)
		
		applyTheme()
	}
	
	override func renderContentUpdates() {
		if !isViewLoaded { return }
		
		render(dataSource)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		(collectionView.collectionViewLayout as! FieldHeightSizingLayout).est = true
	}
}

private extension SlideTestController {
	//	MARK:- Internal
	
	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}
	
	func setupUI() {
	}
	
	func prepare(_ dataSource: SlideTestDataSource?) {
		dataSource?.controller = self
	}
	
	func render(_ dataSource: SlideTestDataSource?) {
		collectionView.reloadData()
	}
}
