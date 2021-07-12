//
//  LoginDataSource.swift
//

import UIKit

final class LoginDataSource: FieldsDataSource {
	//	Model
	var user: User?

	private var fields: [FieldModel] = []


	//	Init

	init(_ user: User) {
		self.user = user
		super.init()

		prepareFields()
	}

	enum FieldId: String, CaseIterable {
		case info
		case username
		case password
		case forgotpassword
		case submit
	}

	//	MARK: FieldDataSource

	override func registerReusableElements(for cv: UICollectionView) {
		cv.register(FormTextCell.self, withReuseIdentifier: FieldId.info.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)
		cv.register(ForgotPassCell.self, withReuseIdentifier: FieldId.forgotpassword.rawValue)
		cv.register(FormButtonCell.self, withReuseIdentifier: FieldId.submit.rawValue)
	}

	override func cell(collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell {
		let model = fields[indexPath.item]

		switch model {
			case let model as TextFieldModel:
				let cell: TextFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
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

			case let model as BasicModel:
				switch model.id {
					case FieldId.forgotpassword.rawValue:
						let cell: ForgotPassCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
						return cell

					default:
						break
				}

			default:
				break
		}

		preconditionFailure("Unknown cell model")
	}

	override func populateSnapshot() -> FieldsDataSource.Snapshot {
		var snapshot = Snapshot()

		snapshot.appendSections(["0"])
		snapshot.appendItems(
			fields.map { $0.id }
		)

		return snapshot
	}
}

//	MARK: Internal

extension LoginDataSource {
	func field(at indexPath: IndexPath) -> FieldModel {
		return fields[indexPath.item]
	}
}

private extension LoginDataSource {
	func prepareFields() {

		fields.append({
			let model = FormTextModel(id: FieldId.info.rawValue,
								  title: NSLocalizedString("Announcement", comment: ""),
								  value: NSLocalizedString("System will be offline tonight for maintenance, from midnight to 6 AM. Please submit your work before that.", comment: ""))
			model.customSetup = { label in
				label.textColor = .blue
				label.superview?.backgroundColor = .clear	//	sneaky little hack
			}
			return model
		}())

		fields.append({
			let model = TextFieldModel(id: FieldId.username.rawValue,
									   title: NSLocalizedString("Username", comment: ""),
									   value: user?.username)
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
			let model = TextFieldModel(id: FieldId.password.rawValue,
									   title: NSLocalizedString("Password", comment: ""),
									   value: user?.password)
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

		fields.append({
			let model = BasicModel(id: FieldId.forgotpassword.rawValue)
			return model
		}())

		fields.append({
			let model = FormButtonModel(
				id: FieldId.submit.rawValue,
				title: NSLocalizedString("Sign in", comment: "")
			)
			model.action = realSubmit
			return model
		}())
	}

	func realSubmit() {
		//	validate
		//	submit to middleware/data

		//	in essence: re-run `prepareFields()` and update `fields` array
	}
}
