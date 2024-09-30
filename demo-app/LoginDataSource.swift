//
//  LoginDataSource.swift
//

import UIKit

final class LoginDataSource: FieldsDataSource {
	//	Model
	var user: User?
	
	///	View-model for the form fields
	private var fieldIds: [FieldSection.ID] = []
	private var fieldsMap: [FieldModel.ID: FieldModel] = [:]
	
	//	Init
	
	init(_ user: User) {
		self.user = user
		super.init()
		
		areSeparatorsEnabled = false
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
		super.registerReusableElements(for: cv)
		
		[FieldId.username, .password].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, TextFieldModel.ID>(cellNib: TextFieldCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? TextFieldCell,
					let model = self?.fieldsMap[itemIdentifier] as? TextFieldModel
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		[FieldId.submit].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, FormButtonModel.ID>(cellNib: FormButtonCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? FormButtonCell,
					let model = self?.fieldsMap[itemIdentifier] as? FormButtonModel
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		[FieldId.info].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, FormTextModel.ID>(cellNib: FormTextCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? FormTextCell,
					let model = self?.fieldsMap[itemIdentifier] as? FormTextModel
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		[FieldId.forgotpassword].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, FieldModel.ID>(cellNib: ForgotPassCell.nib) {
				_, _, _ in
			}
		}
	}
	
	override func populateSnapshot(flowIdentifier fid: String) -> FieldsDataSource.Snapshot {
		var snapshot = Snapshot()
		
		let sectionId = "form"
		snapshot.appendSections([sectionId])
		snapshot.appendItems(fieldIds, toSection: sectionId)
		snapshot.reconfigureItems(fieldIds)
		
		return snapshot
	}
}

//	MARK: Internal

extension LoginDataSource {
	func field(at indexPath: IndexPath) -> FieldId? {
		guard let itemIdentifier = gridSource.itemIdentifier(for: indexPath) else { return nil }
		return FieldId(rawValue: itemIdentifier)
	}
}

private extension LoginDataSource {
	func prepareFields() {
		fieldIds.removeAll()
		fieldsMap.removeAll()
		
		var fields: [FieldModel] = []
		fields.append({
			let model = FormTextModel(
				id: FieldId.info.rawValue,
				title: NSLocalizedString("Announcement", comment: ""),
				value: NSLocalizedString("System will be offline tonight for maintenance, from midnight to 6 AM. Please submit your work before that.", comment: "")
			)
			model.customSetup = { label in
				label.textColor = .blue
				label.superview?.backgroundColor = .clear	//	sneaky little hack
			}
			return model
		}())
		
		fields.append({
			let model = TextFieldModel(
				id: FieldId.username.rawValue,
				title: NSLocalizedString("Username", comment: ""),
				value: user?.username
			)
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
			let model = TextFieldModel(
				id: FieldId.password.rawValue,
				title: NSLocalizedString("Password", comment: ""),
				value: user?.password
			)
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
			let model = FieldModel(id: FieldId.forgotpassword.rawValue)
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
		
		fieldIds = fields.map { $0.id }
		fields.forEach { fieldsMap[$0.id] = $0 }
	}
	
	func realSubmit() {
		//	validate
		//	submit to middleware/data
		
		//	in essence: re-run `prepareFields()` and update `fields` array
	}
}
