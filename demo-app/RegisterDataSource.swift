import UIKit

final class RegisterDataSource: FieldsDataSource {
	lazy var dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		return df
	}()

	//	Model
	private var user: User?

	private var shouldAddAddress = true {
		didSet { processAddressToggle() }
	}

	private var usePostalAsBillingAddress = true {
		didSet { processBillingAddressToggle() }
	}

	private var preferredInventoryCategory: InventoryCategory? = InventoryCategory.allCategories.first
	private let inventoryCategories: [InventoryCategory] = InventoryCategory.allCategories

	private var note: String?

	//	Init

	init(_ user: User) {
		self.user = user
		if user.postalAddress != nil {
			self.shouldAddAddress = true
		}
		if user.postalAddress == user.billingAddress {
			self.usePostalAsBillingAddress = true
		}
		super.init()

		prepareFields()
	}


	//	Fields
	//	(placed here to be visible to RegisterController)

	private var sections: [FieldSection] = []

	enum SectionId: String {
		case account
		case personal
		case address
		case prefs
		case other
	}

	enum FieldId: String {
		case username
		case password

		case title
		case firstName
		case lastName
		case dateOfBirth

		case addressToggle
		case street
		case city
		case postcode
		case country

		case billingAddressToggle
		case billingStreet
		case billingCity
		case billingPostcode
		case billingCountry
		case billingNote

		case inventoryCategory

		case note
		case submit
	}

	//	MARK: FieldDataSource

	override func registerReusableElements(for cv: UICollectionView) {
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.username.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.password.rawValue)

		cv.register(PickerCell.self, withReuseIdentifier: FieldId.title.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.firstName.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.lastName.rawValue)
		cv.register(DatePickerCell.self, withReuseIdentifier: FieldId.dateOfBirth.rawValue)

		cv.register(ToggleCell.self, withReuseIdentifier: FieldId.addressToggle.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.street.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.postcode.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.city.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.country.rawValue)

		cv.register(ToggleCell.self, withReuseIdentifier: FieldId.billingAddressToggle.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.billingStreet.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.billingPostcode.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.billingCity.rawValue)
		cv.register(TextFieldCell.self, withReuseIdentifier: FieldId.billingCountry.rawValue)
		cv.register(FormTextCell.self, withReuseIdentifier: FieldId.billingNote.rawValue)

		cv.register(TextViewCell.self, withReuseIdentifier: FieldId.note.rawValue)
		cv.register(FormButtonCell.self, withReuseIdentifier: FieldId.submit.rawValue)

		for ic in inventoryCategories {
			cv.register(InventoryCategoryCell.self, withReuseIdentifier: ic.fieldId)
		}

		//	also for header/footer views

		cv.register(SectionHeaderView.self, kind: SectionHeaderView.kind)
		cv.register(SectionFooterView.self, kind: SectionFooterView.kind)
	}

	override func cell(collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell {
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

			case let model as FormTextModel:
				let cell: FormTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			case let model as ToggleModel:
				let cell: ToggleCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			case let model as DatePickerModel:
				let cell: DatePickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			case let model as FormButtonModel:
				let cell: FormButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			case let model as SingleValueModel<InventoryCategory>:
				let cell: InventoryCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			case let model as PickerModel<PersonTitle>:
				let cell: PickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, forIndexPath: indexPath)
				cell.populate(with: model)
				return cell

			default:
				preconditionFailure("Unknown cell model")
		}
	}

	override func layoutSectionSupplementaryItems(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> [NSCollectionLayoutBoundarySupplementaryItem] {
		var arr: [NSCollectionLayoutBoundarySupplementaryItem] = []

		if sections[sectionIndex].header != nil {
			let size = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(44)
			)
			let element = NSCollectionLayoutBoundarySupplementaryItem(
				layoutSize: size,
				elementKind: SectionHeaderView.kind,
				alignment: .topLeading
			)
			arr.append(element)
		}

		if sections[sectionIndex].footer != nil {
			let size = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(66)
			)
			let element = NSCollectionLayoutBoundarySupplementaryItem(
				layoutSize: size,
				elementKind: SectionFooterView.kind,
				alignment: .bottomLeading
			)
			arr.append(element)
		}

		return arr
	}

	override func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
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
				preconditionFailure("Unexpected supplementary view kind: \( kind )")
		}
	}

	override func createLayoutSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let id = sections[sectionIndex].id

		switch id {
			case SectionId.prefs.rawValue:
				return createLayoutPrefsSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)

			default:
				return super.createLayoutSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		}
	}

	private func createLayoutPrefsSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let aw = layoutEnvironment.container.contentSize.width
		let fieldsCount = sections[sectionIndex].fields.count
		let itemWidth = max(80, aw / min(inventoryColumnSplit, CGFloat(fieldsCount)))
		let itemHeight = min(120, itemWidth)

		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .absolute(itemWidth),
				heightDimension: .absolute(itemHeight)
			)
		)

		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(itemHeight)
			),
			subitem: item,
			count: fieldsCount
		)

		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = layoutSectionSupplementaryItems(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		return section
	}

	override func populateSnapshot() -> FieldsDataSource.Snapshot {
		var snapshot = Snapshot()

		snapshot.appendSections(
			sections.map { $0.id }
		)
		for section in sections {
			snapshot.appendItems(
				section.fields.map { $0.id },
				toSection: section.id
			)
		}

		return snapshot
	}
}

private extension RegisterDataSource {
	func processAddressToggle() {
		if !shouldAddAddress {
			user?.postalAddress = nil
			user?.billingAddress = nil
		}

		prepareFields()
		render(animated: true)
	}

	func processBillingAddressToggle() {
		if usePostalAsBillingAddress {
			let a = user?.postalAddress
			user?.billingAddress = a
		} else {
			user?.billingAddress = nil
		}

		prepareFields()
		render(animated: true)
	}

	//	MARK: Data source for the CV

	func prepareFields() {
		sections.removeAll()

		sections.append( buildAccountSection() )
		if shouldAddAddress {
			sections.append( buildAddressSection() )
		}
		sections.append( buildPrefsSection() )
		sections.append( buildPersonalSection() )
		sections.append( buildOtherSection() )
	}

	func buildAccountSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.account.rawValue,
			header: NSLocalizedString("Account information", comment: ""),
			footer: NSLocalizedString("Please use strong passwords. We encourage usage of password keepers and generators.", comment: "")
		)

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

		section.fields.append({
			let model = ToggleModel(id: FieldId.addressToggle.rawValue, title: NSLocalizedString("Add postal address?", comment: ""), value: shouldAddAddress)
			model.valueChanged = { [weak self] isOn, cell in
				//	required: update raw data
				self?.shouldAddAddress = isOn
				model.value = isOn

				//	optional: after you update the field model,
				//	repopulate the cell with updated model
				(cell as? ToggleCell)?.populate(with: model)
			}
			return model
			}())

		return section
	}
	
	func buildPersonTitleModel1() -> FieldModel {
		let model = PickerModel<PersonTitle>(id: FieldId.title.rawValue,
								title: NSLocalizedString("Title", comment: ""),
								value: user?.title,
								values: PersonTitle.allCases,
								valueFormatter: { return $0?.rawValue })
		model.displayPicker = {
			[weak self] cell in
			if model.values.count == 0 { return }

			let provider = PickerOptionsProvider<PersonTitle, PickerOptionTextCell>(for: cell, with: model)
			let vc = PickerOptionsListController(provider: provider)
			self?.controller?.show(vc, sender: nil)
		}
		model.selectedValueAtIndex = {
			[weak self, weak model] index, cell in
			guard let self = self, let index = index, let model = model else { return }

			let t = model.values[index]
			self.user?.title = t
			model.value = t

			//	refresh originating's Cell display
			if let cell = cell as? PickerCell {
				cell.populate(with: model)
			}
			//	pop VC back to the form
			self.controller?.navigationController?.popViewController(animated: true)
		}
		return model
	}

	func buildPersonalSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.personal.rawValue,
			header: NSLocalizedString("Personal information", comment: "")
		)

		section.fields.append(
			buildPersonTitleModel1()
		)

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

		section.fields.append({
			let model = DatePickerModel(id: FieldId.dateOfBirth.rawValue,
										title: NSLocalizedString("Date of birth", comment: ""),
										value: user?.dateOfBirth,
										formatter: dateFormatter)
			model.customSetup = { picker, cell in
				picker.datePickerMode = .date
			}
			model.valueChanged = {
				[weak self] date, cell in

				self?.user?.dateOfBirth = date
				model.value = date
			}
			return model
			}())

		return section
	}

	func buildAddressSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.address.rawValue,
			header: NSLocalizedString("Postal Address", comment: "")
		)

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

		section.fields.append({
			let model = ToggleModel(id: FieldId.billingAddressToggle.rawValue, title: NSLocalizedString("Use as billing address?", comment: ""), value: usePostalAsBillingAddress)
			model.valueChanged = { [weak self] isOn, cell in
				//	required: update raw data
				self?.usePostalAsBillingAddress = isOn
			}
			return model
			}())

		if !usePostalAsBillingAddress {

			section.fields.append({
				let model = TextFieldModel(id: FieldId.billingStreet.rawValue, title: NSLocalizedString("Billing Street & building/apt no", comment: ""), value: user?.billingAddress?.street)
				model.customSetup = { textField in
					textField.textContentType = .fullStreetAddress
				}
				model.valueChanged = { [weak self] string, _ in
					self?.user?.billingAddress?.street = string
					model.value = string
				}
				return model
				}())

			section.fields.append({
				let model = TextFieldModel(id: FieldId.billingCity.rawValue, title: NSLocalizedString("City", comment: ""), value: user?.billingAddress?.city)
				model.customSetup = { textField in
					textField.textContentType = .addressCity
				}
				model.valueChanged = { [weak self] string, _ in
					self?.user?.billingAddress?.city = string
					model.value = string
				}
				return model
				}())

			section.fields.append({
				let model = TextFieldModel(id: FieldId.billingPostcode.rawValue, title: NSLocalizedString("Post code", comment: ""), value: user?.billingAddress?.postCode)
				model.customSetup = { textField in
					textField.textContentType = .postalCode
				}
				model.valueChanged = { [weak self] string, _ in
					self?.user?.billingAddress?.postCode = string
					model.value = string
				}
				return model
				}())

			section.fields.append({
				let model = TextFieldModel(id: FieldId.billingCountry.rawValue, title: NSLocalizedString("Country", comment: ""), value: user?.billingAddress?.isoCountryCode)
				model.customSetup = { textField in
					textField.textContentType = .countryName
				}
				model.valueChanged = { [weak self] string, _ in
					self?.user?.billingAddress?.isoCountryCode = string
					model.value = string
				}
				return model
				}())
		}

		section.fields.append({
			let model = FormTextModel(id: FieldId.billingNote.rawValue,
								  title: "",
								  value: NSLocalizedString("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", comment: ""))
			model.customSetup = { label in
				label.textColor = .gray
				label.superview?.backgroundColor = .clear
			}
			return model
			}())

		return section
	}

	func buildOtherSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.other.rawValue,
			header: NSLocalizedString("Extra stuff", comment: "")
		)

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

		section.fields.append({
			let model = FormButtonModel(id: FieldId.submit.rawValue,
									title: NSLocalizedString("Create account", comment: ""))
			return model
			}())

		return section
	}

	func buildPrefsSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.prefs.rawValue,
			header: NSLocalizedString("Preferred category", comment: "")
		)

		for ic in inventoryCategories {
			section.fields.append(
				inventoryCategoryField(for: ic)
			)
		}

		return section
	}

	func inventoryCategoryField(for item: InventoryCategory) -> FieldModel {
		let model = SingleValueModel(id: item.fieldId,
									 value: item,
									 isChosen: preferredInventoryCategory == item)
		model.valueSelected = {
			[weak self] item, cell in
			guard let self = self else { return }

			self.preferredInventoryCategory = item

			self.prepareFields()
			self.render(animated: false)
		}
		return model
	}
}

fileprivate extension InventoryCategory {
	///	A value to be used as `reuseIdentifier` for each inventory-category form field.
	var fieldId: String {
		return "\( RegisterDataSource.FieldId.inventoryCategory.rawValue )-\( id.rawValue )"
	}
}


extension RegisterDataSource {
	func section(at index: Int) -> FieldSection {
		return sections[index]
	}

	func field(at indexPath: IndexPath) -> FieldModel {
		let field = sections[indexPath.section].fields[indexPath.item]
		return field
	}
}

private extension RegisterDataSource {
	var addressColumnSplit: CGFloat {
		let c = controller?.traitCollection.preferredContentSizeCategory ?? .large

		if c <= .large {
			return 4
		} else if c <= .accessibilityMedium {
			return 2
		} else {
			return 1
		}
	}

	var personTitleColumnSplit: CGFloat {
		let c = controller?.traitCollection.preferredContentSizeCategory ?? .large

		if c <= .large {
			return 5
		} else if c <= .accessibilityMedium {
			return 4
		} else if c <= .accessibilityExtraLarge {
			return 3
		} else {
			return 1
		}
	}

	var inventoryColumnSplit: CGFloat {
		let c = controller?.traitCollection.preferredContentSizeCategory ?? .large

		if c <= .large {
			return 4
		} else if c <= .extraExtraLarge {
			return 3
		} else if c <= .accessibilityMedium {
			return 2
		} else {
			return 1
		}
	}
}
