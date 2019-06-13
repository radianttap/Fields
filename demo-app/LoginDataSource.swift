//
//  LoginDataSource.swift
//

import UIKit

final class LoginDataSource: NSObject {
	//	Dependencies
	weak var collectionView: UICollectionView? {
		didSet { prepareCollectionView() }
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
		case username
		case password
	}

	func prepareFields() {
		fields.append({
			let model = TextFieldModel(id: FieldId.username.rawValue,
									   title: NSLocalizedString("Username", comment: ""),
									   value: user?.username)
			return model
		}())

		fields.append({
			let model = TextFieldModel(id: FieldId.password.rawValue,
									   title: NSLocalizedString("Password", comment: ""),
									   value: user?.password)
			return model
		}())

	}
}

extension LoginDataSource: UICollectionViewDataSource {
	private func prepareCollectionView() {
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)
	}

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
		default:
			fatalError("Unknown cell model")
		}
	}
}
