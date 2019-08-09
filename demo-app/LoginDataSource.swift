//
//  LoginDataSource.swift
//

import UIKit

final class LoginDataSource: NSObject {
	//	Dependencies
	weak var controller: LoginController? {
		didSet { prepareView() }
	}

	//	Model
	var user: User?

	private var fields: [FieldModel] = []


	//	Init

	init(_ user: User) {
		self.user = user
		super.init()

		prepareFields()
	}
}

private extension LoginDataSource {
	enum FieldId: String {
		case info
		case username
		case password
	}

	func prepareFields() {

		fields.append({
			let model = TextModel(id: FieldId.info.rawValue,
								  title: NSLocalizedString("Announcement", comment: ""),
								  value: NSLocalizedString("System will be offline tonight for maintenance, from midnight to 6 AM. Please submit your work before that.", comment: ""))
			model.customSetup = { label in
				label.textColor = .blue
				label.superview?.backgroundColor = .clear	//	sneaky little hack
			}
			return model
		}())

		fields.append({
			let model = TextFieldModel(id: FieldId.username.rawValue, title: NSLocalizedString("Username", comment: ""), value: user?.username)
			model.customSetup = { textField in
				textField.textContentType = .username
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.username = string
				model.value = string
			}
			return model
		}())

		fields.append({
			let model = TextFieldModel(id: FieldId.password.rawValue, title: NSLocalizedString("Password", comment: ""), value: user?.password)
			model.customSetup = { textField in
				textField.textContentType = .password
				textField.isSecureTextEntry = true
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.password = string
				model.value = string
			}
			return model
		}())
	}
}

private extension LoginDataSource {
	func prepareView() {
		guard let cv = controller?.collectionView else { return }

		cv.register(TextCell.self, withReuseIdentifier: FieldId.info.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)
		cv.dataSource = self
	}

	func renderContentUpdates() {
		controller?.renderContentUpdates()
	}
}

extension LoginDataSource: UICollectionViewDataSource {
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

		case let model as TextModel:
			let cell: TextCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell

		default:
			fatalError("Unknown cell model")
		}
	}
}
