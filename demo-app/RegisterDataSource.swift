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

	var shouldAddAddress = false {
		didSet { processAddressToggle() }
	}

	private var sections: [Section] = []

	//	Init

	init(_ user: User) {
		self.user = user
		self.shouldAddAddress = user.postalAddress != nil
		super.init()

		prepareFields()
	}


	//	Fields
	//	(placed here to be visible to RegisterController)

	enum FieldId: String {
		case username
		case password

		case title
		case firstName
		case lastName

		case addressToggle
		case street
		case city
		case postcode
		case country
	}

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
}

private extension RegisterDataSource {
	func processContentUpdates() {
		collectionView?.reloadData()
	}

	func processAddressToggle() {
		defer {
			prepareFields()
			processContentUpdates()
		}

		if !shouldAddAddress {
			user?.postalAddress = nil
		}
	}

	//	MARK: Data source for the CV

	func prepareFields() {
		sections.removeAll()

		sections.append( buildAccountSection() )
		sections.append( buildPersonalSection() )
		sections.append( buildAddressSection() )
	}

	func buildAccountSection() -> Section {
		var section = Section(header: NSLocalizedString("Account information", comment: ""),
							  footer: NSLocalizedString("Please use strong passwords. We encourage usage of password keepers and generators.", comment: ""))

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

	func buildPersonalSection() -> Section {
		var section = Section(header: NSLocalizedString("Personal information", comment: ""))

		section.fields.append({
			let model = PickerModel<PersonTitle, PickerOptionTextCell>(id: FieldId.title.rawValue,
											title: NSLocalizedString("Title", comment: ""),
											value: user?.title,
											values: PersonTitle.allCases,
											valueFormatter: { return $0?.rawValue })
			model.displayPicker = { [weak self] in
				let vc = PickerOptionsListController<PersonTitle, PickerOptionTextCell>()
				vc.populate(with: model)
				self?.collectionView?.fieldsController?.show(vc, sender: nil)
			}
			model.valueChanged = { [weak self] t in
				self?.user?.title = t
				model.value = t
				//	refresh display
				self?.collectionView?.reloadData()
				//	pop VC back to the form
				self?.collectionView?.fieldsController?.navigationController?.popViewController(animated: true)
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.firstName.rawValue, title: NSLocalizedString("First (given) name", comment: ""), value: user?.firstName)
			model.customSetup = { textField in
				textField.textContentType = .givenName
			}
			model.valueChanged = { [weak self] string in
				self?.user?.firstName = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.lastName.rawValue, title: NSLocalizedString("Last (family) name", comment: ""), value: user?.lastName)
			model.customSetup = { textField in
				textField.textContentType = .familyName
			}
			model.valueChanged = { [weak self] string in
				self?.user?.lastName = string
			}
			return model
			}())

		return section
	}

	func buildAddressSection() -> Section {
		var section = Section(header: NSLocalizedString("Postal Address", comment: ""))

		section.fields.append({
			let model = ToggleModel(id: FieldId.addressToggle.rawValue, title: NSLocalizedString("Add postal address?", comment: ""), value: shouldAddAddress)
			model.valueChanged = { [weak self] isOn in
				self?.shouldAddAddress = isOn
			}
			return model
			}())

		if !shouldAddAddress {
			return section
		}

		section.fields.append({
			let model = TextFieldModel(id: FieldId.street.rawValue, title: NSLocalizedString("Street & building/apt no", comment: ""), value: user?.postalAddress?.street)
			model.customSetup = { textField in
				textField.textContentType = .fullStreetAddress
			}
			model.valueChanged = { [weak self] string in
				self?.user?.postalAddress?.street = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.postcode.rawValue, title: NSLocalizedString("Post code", comment: ""), value: user?.postalAddress?.postCode)
			model.customSetup = { textField in
				textField.textContentType = .postalCode
			}
			model.valueChanged = { [weak self] string in
				self?.user?.postalAddress?.postCode = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.city.rawValue, title: NSLocalizedString("City", comment: ""), value: user?.postalAddress?.city)
			model.customSetup = { textField in
				textField.textContentType = .addressCity
			}
			model.valueChanged = { [weak self] string in
				self?.user?.postalAddress?.city = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.country.rawValue, title: NSLocalizedString("Country", comment: ""), value: user?.postalAddress?.isoCountryCode)
			model.customSetup = { textField in
				textField.textContentType = .countryName
			}
			model.valueChanged = { [weak self] string in
				self?.user?.postalAddress?.isoCountryCode = string
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

		collectionView?.register(PickerCell.self, withReuseIdentifier: FieldId.title.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.firstName.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.lastName.rawValue)

		collectionView?.register(ToggleCell.self, withReuseIdentifier: FieldId.addressToggle.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.street.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.postcode.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.city.rawValue)
		collectionView?.register(TextFieldCell.self, withReuseIdentifier: FieldId.country.rawValue)

		collectionView?.register(SectionHeaderView.self, kind: SectionHeaderView.kind)
		collectionView?.register(SectionFooterView.self, kind: SectionFooterView.kind)
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let s = sections[indexPath.section]

		switch kind {
		case SectionHeaderView.kind:
			let v: SectionHeaderView = collectionView.dequeueReusableView(kind: kind, atIndexPath: indexPath)
			v.populate(with: s.header ?? "")
			return v

		case SectionFooterView.kind:
			let v: SectionFooterView = collectionView.dequeueReusableView(kind: kind, atIndexPath: indexPath)
			v.populate(with: s.footer ?? "")
			return v

		default:
			fatalError("Unexpected supplementary view kind: \( kind )")
		}
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

		case let model as ToggleModel:
			let cell: ToggleCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell

		case let model as PickerModel<PersonTitle, PickerOptionTextCell>:
			let cell: PickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell

		default:
			fatalError("Unknown cell model")
		}
	}

	func section(at index: Int) -> Section {
		return sections[index]
	}

	func field(at indexPath: IndexPath) -> FieldModel {
		let field = sections[indexPath.section].fields[indexPath.item]
		return field
	}
}
