//
//  RegisterDataSource.swift
//

import UIKit

final class RegisterDataSource: NSObject {
	//	Dependencies
	weak var collectionView: UICollectionView? {
		didSet { prepareCollectionView() }
	}

	//	Model
	var user: User?

	private var sections: [Section] = []

	//	Init

	init(_ user: User) {
		self.user = user
		super.init()

		sections.append(
			buildAccountSection()
		)
	}


	//	Fields
	//	(placed here to be visible to RegisterController)

	enum FieldId: String {
		case username
		case password

		case firstName
		case lastName

		case street
		case city
		case postcode
		case country
	}
}

private extension RegisterDataSource {
	struct Section {
		var header: String? = nil
		var fields: [FieldModel] = []
		var footer: String? = nil

		init(header: String? = nil, footer: String? = nil, fields: [FieldModel] = []) {
			self.header = header
			self.footer = footer
			self.fields = fields
		}
	}

	func buildAccountSection() -> Section {
		var section = Section(header: NSLocalizedString("Account information", comment: ""),
							  footer: NSLocalizedString("Please use strong passwords. We encourage usage of password keepers.", comment: ""))

		section.fields.append({
			let model = TextFieldModel(id: FieldId.username.rawValue, title: NSLocalizedString("Username", comment: ""), value: user?.username)
			model.customSetup = { textField in
				textField.textContentType = .username
			}
			model.valueChanged = { [weak self] string in
				self?.user?.username = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.password.rawValue, title: NSLocalizedString("Password", comment: ""), value: user?.password)
			model.customSetup = { textField in
				textField.textContentType = .password
				textField.isSecureTextEntry = true
			}
			model.valueChanged = { [weak self] string in
				self?.user?.password = string
			}
			return model
			}())

		return section
	}

}

extension RegisterDataSource: UICollectionViewDataSource {
	private func prepareCollectionView() {
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[section].fields.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = sections[indexPath.section].fields[indexPath.item]

		switch model {
		case let model as TextFieldModel:
			let cell: TextFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell
		default:
			fatalError("Unknown cell model")
		}
	}

	func field(at indexPath: IndexPath) -> FieldModel {
		let field = sections[indexPath.section].fields[indexPath.item]
		return field
	}
}
