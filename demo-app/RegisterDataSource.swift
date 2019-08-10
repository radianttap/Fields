//
//  RegisterDataSource.swift
//

import UIKit

final class RegisterDataSource: NSObject {
	//	Dependencies
	weak var controller: FieldsCollectionController? {
		didSet { prepareView() }
	}

	//	Model
	var user: User?

	var shouldAddAddress = false {
		didSet { processAddressToggle() }
	}

	var note: String?

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

		case note
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
	func prepareView() {
		guard let cv = controller?.collectionView else { return }

		//	reusability is not needed here
		//	(it can actually lead to problems),
		//	so register separate Cell for each field

		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)

		cv.register(PickerCell.self, withReuseIdentifier: FieldId.title.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.firstName.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.lastName.rawValue)

		cv.register(ToggleCell.self, withReuseIdentifier: FieldId.addressToggle.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.street.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.postcode.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.city.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.country.rawValue)

		cv.register(TextViewCell.self, withReuseIdentifier: FieldId.note.rawValue)

		//	also for header/footer views

		cv.register(SectionHeaderView.self, kind: SectionHeaderView.kind)
		cv.register(SectionFooterView.self, kind: SectionFooterView.kind)

		cv.dataSource = self
	}

	func processContentUpdates() {
		controller?.renderContentUpdates()
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
		sections.append( buildOtherSection() )
	}

	func buildAccountSection() -> Section {
		var section = Section(header: NSLocalizedString("Account information", comment: ""),
							  footer: NSLocalizedString("Please use strong passwords. We encourage usage of password keepers and generators.", comment: ""))

		section.fields.append({
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

		section.fields.append({
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

		return section
	}

	func buildPersonalSection() -> Section {
		var section = Section(header: NSLocalizedString("Personal information", comment: ""))

		section.fields.append({
			let model = PickerModel(id: FieldId.title.rawValue,
											title: NSLocalizedString("Title", comment: ""),
											value: user?.title,
											values: PersonTitle.allCases,
											valueFormatter: { return $0?.rawValue })
			model.displayPicker = { [weak self] cell in
				if model.values.count == 0 { return }

				let provider = PickerOptionsProvider<PersonTitle, PickerOptionTextCell>(for: cell, with: model)
				let vc = PickerOptionsListController(provider: provider)
				self?.controller?.show(vc, sender: nil)
			}
			model.valueChanged = { [weak self, weak model] t, cell in
				guard let self = self, let model = model else { return }

				self.user?.title = t
				model.value = t

				//	refresh display
				cell.populate(with: model)
				//	pop VC back to the form
				self.controller?.navigationController?.popViewController(animated: true)
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.firstName.rawValue, title: NSLocalizedString("First (given) name", comment: ""), value: user?.firstName)
			model.customSetup = { textField in
				textField.textContentType = .givenName
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.firstName = string
				model.value = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.lastName.rawValue, title: NSLocalizedString("Last (family) name", comment: ""), value: user?.lastName)
			model.customSetup = { textField in
				textField.textContentType = .familyName
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.lastName = string
				model.value = string
			}
			return model
			}())

		return section
	}

	func buildAddressSection() -> Section {
		var section = Section(header: NSLocalizedString("Postal Address", comment: ""))

		section.fields.append({
			let model = ToggleModel(id: FieldId.addressToggle.rawValue, title: NSLocalizedString("Add postal address?", comment: ""), value: shouldAddAddress)
			model.valueChanged = { [weak self] isOn, cell in
				//	required: update raw data
				self?.shouldAddAddress = isOn
				model.value = isOn

				//	optional: after you update the field model,
				//	repopulate the cell with updated model
				cell.populate(with: model)
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
			model.valueChanged = { [weak self] string, _ in
				self?.user?.postalAddress?.street = string
				model.value = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.postcode.rawValue, title: NSLocalizedString("Post code", comment: ""), value: user?.postalAddress?.postCode)
			model.customSetup = { textField in
				textField.textContentType = .postalCode
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.postalAddress?.postCode = string
				model.value = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.city.rawValue, title: NSLocalizedString("City", comment: ""), value: user?.postalAddress?.city)
			model.customSetup = { textField in
				textField.textContentType = .addressCity
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.postalAddress?.city = string
				model.value = string
			}
			return model
			}())

		section.fields.append({
			let model = TextFieldModel(id: FieldId.country.rawValue, title: NSLocalizedString("Country", comment: ""), value: user?.postalAddress?.isoCountryCode)
			model.customSetup = { textField in
				textField.textContentType = .countryName
			}
			model.valueChanged = { [weak self] string, _ in
				self?.user?.postalAddress?.isoCountryCode = string
				model.value = string
			}
			return model
			}())

		return section
	}

	func buildOtherSection() -> Section {
		var section = Section(header: NSLocalizedString("Extra stuff", comment: ""))

		section.fields.append({
			let model = TextViewModel(id: FieldId.note.rawValue,
									  minimalHeight: 132,
									  title: NSLocalizedString("Additional note", comment: ""),
									  value: note)
			model.valueChanged = { [weak self] string, _ in
				self?.note = string
				model.value = string
			}
			return model
		}())

		return section
	}
}

extension RegisterDataSource: UICollectionViewDataSource {
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

		case let model as TextViewModel:
			let cell: TextViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell

		case let model as ToggleModel:
			let cell: ToggleCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
			cell.populate(with: model)
			return cell

		case let model as PickerModel<PersonTitle>:
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
