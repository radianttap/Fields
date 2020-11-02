import UIKit

final class SlideTestDataSource: NSObject {
	//	Dependencies
	weak var controller: SlideTestController? {
		didSet { prepareView() }
	}
	
	//	Model
	var name: String?

	var flag: Bool {
		didSet { processAnnouncementsToggle() }
	}
	
	private var fields: [FieldModel] = []
	
	
	//	Init
	
	init(_ flag: Bool = true) {
		self.flag = flag
		super.init()
		
		prepareFields()
	}
	
	enum FieldId: String {
		case info
		case name
		case flag
		case submit
	}
}

private extension SlideTestDataSource {
	func prepareFields() {
		fields.removeAll()
		
		fields.append({
			let model = ToggleModel(id: FieldId.flag.rawValue, title: NSLocalizedString("Display announcements", comment: ""), value: flag)
			model.valueChanged = {
				[weak self] isOn, _ in

				self?.flag = isOn
			}
			return model
		}())
		
		if flag {
			fields.append({
				let model = FormTextModel(id: FieldId.info.rawValue,
										  title: NSLocalizedString("Announcement", comment: ""),
										  value: NSLocalizedString("System will be offline tonight for maintenance, from midnight to 6 AM. Please submit your work before that.", comment: ""))
				model.customSetup = { label in
					label.superview?.backgroundColor = .clear	//	sneaky little hack
				}
				return model
				}())
		}
		
		fields.append({
			let model = TextFieldModel(id: FieldId.name.rawValue,
									   title: NSLocalizedString("Name", comment: ""),
									   value: name)
			model.customSetup = { textField in
				textField.textContentType = .name
			}
			model.valueChanged = {
				[weak self] string, _ in
				
				self?.name = string
				model.value = string
			}
			return model
		}())
		
		fields.append({
			let model = FormButtonModel(id: FieldId.submit.rawValue,
										title: NSLocalizedString("Update", comment: ""))
			return model
		}())
	}
}

private extension SlideTestDataSource {
	func prepareView() {
		guard let cv = controller?.collectionView else { return }
		
		cv.register(ToggleCell.self, withReuseIdentifier: FieldId.flag.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.name.rawValue)
		cv.register(FormTextCell.self, withReuseIdentifier: FieldId.info.rawValue)
		cv.register(FormButtonCell.self, withReuseIdentifier: FieldId.submit.rawValue)
		cv.dataSource = self
	}
	
	func renderContentUpdates() {
		controller?.renderContentUpdates()
	}
	
	func processAnnouncementsToggle() {
		guard let cv = self.controller?.collectionView else { return }
		
		cv.performBatchUpdates({
			prepareFields()
			
			if
				let item = fields.firstIndex(where: { $0.id == FieldId.flag.rawValue })
			{
				let indexPath = IndexPath(item: item+1, section: 0)
				if flag {
					cv.insertItems(at: [indexPath])
				} else {
					cv.deleteItems(at: [indexPath])
				}
			} else {
				cv.reloadData()
			}
		}, completion: nil)
	}
}

extension SlideTestDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fields.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = fields[indexPath.item]
		
		switch model {
			case let model as TextFieldModel:
				let cell: TextFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell
			
			case let model as ToggleModel:
				let cell: ToggleCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell
			
			case let model as FormTextModel:
				let cell: FormTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell
			
			case let model as FormButtonModel:
				let cell: FormButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell
			
			default:
				break
		}
		
		preconditionFailure("Unknown cell model")
	}
	
	func field(at indexPath: IndexPath) -> FieldModel {
		let field = fields[indexPath.item]
		return field
	}
}
