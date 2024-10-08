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
		
		areSeparatorsEnabled = false
		prepareFields()
	}
	
	
	//	Fields
	//	(placed here to be visible to RegisterController)
	
	///	View-model for the form fields
	private var sectionIds: [FieldSection.ID] = []
	private var sectionsMap: [FieldSection.ID: FieldSection] = [:]
	private var fieldsMap: [FieldModel.ID: FieldModel] = [:]
	
	private var isPersonTitlePickerExpanded = false
	
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
		super.registerReusableElements(for: cv)
		
		[FieldId.username, .password, .firstName, .lastName, .street, .postcode, .city, .country, .billingStreet, .billingCity, .billingPostcode, .billingCountry].forEach {
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
		
		[FieldId.billingNote].forEach {
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
		
		self.cellRegistrations[FieldId.title.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, PickerModel<PersonTitle>.ID>(cellNib: PickerStackCell.nib) {
			[weak self] cell, indexPath, itemIdentifier in
			guard
				let cell = cell as? PickerStackCell,
				let model = self?.fieldsMap[itemIdentifier] as? PickerModel<PersonTitle>
			else { return }
			
			cell.populate(with: model)
		}

		self.cellRegistrations[FieldId.dateOfBirth.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, DatePickerModel.ID>(cellNib: DatePickerCell.nib) {
			[weak self] cell, indexPath, itemIdentifier in
			guard
				let cell = cell as? DatePickerCell,
				let model = self?.fieldsMap[itemIdentifier] as? DatePickerModel
			else { return }
			
			cell.populate(with: model)
		}
		
		[FieldId.addressToggle, .billingAddressToggle].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, ToggleModel.ID>(cellNib: ToggleCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? ToggleCell,
					let model = self?.fieldsMap[itemIdentifier] as? ToggleModel
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		[FieldId.note].forEach {
			[unowned self] fieldId in
			
			self.cellRegistrations[fieldId.rawValue] = UICollectionView.CellRegistration<UICollectionViewCell, TextViewModel.ID>(cellNib: TextViewCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? TextViewCell,
					let model = self?.fieldsMap[itemIdentifier] as? TextViewModel
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		for ic in inventoryCategories {
			self.cellRegistrations[ic.fieldId] = UICollectionView.CellRegistration<UICollectionViewCell, SingleValueModel<InventoryCategory>.ID>(cellNib: InventoryCategoryCell.nib) {
				[weak self] cell, indexPath, itemIdentifier in
				guard
					let cell = cell as? InventoryCategoryCell,
					let model = self?.fieldsMap[itemIdentifier] as? SingleValueModel<InventoryCategory>
				else { return }
				
				cell.populate(with: model)
			}
		}
		
		//	also for header/footer views

		supplementaryRegistrations[SectionHeaderView.kind] = UICollectionView.SupplementaryRegistration(supplementaryNib: SectionHeaderView.nib, elementKind: SectionHeaderView.kind) {
			[weak self] supplementaryView, kind, indexPath in
			guard
				let self,
				let v = supplementaryView as? SectionHeaderView,
				let fsection = self.sectionsMap[sectionIds[indexPath.section]],
				let s = fsection.header
			else { return }
			
			v.populate(with: s)
		}

		supplementaryRegistrations[SectionFooterView.kind] = UICollectionView.SupplementaryRegistration(supplementaryNib: SectionFooterView.nib, elementKind: SectionFooterView.kind) {
			[weak self] supplementaryView, kind, indexPath in
			guard
				let self,
				let v = supplementaryView as? SectionFooterView,
				let fsection = self.sectionsMap[sectionIds[indexPath.section]],
				let s = fsection.footer
			else { return }
			
			v.populate(with: s)
		}
	}
	
	override func layoutSectionSupplementaryItems(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> [NSCollectionLayoutBoundarySupplementaryItem] {
		var arr: [NSCollectionLayoutBoundarySupplementaryItem] = []
		guard let fsection = sectionsMap[sectionIds[sectionIndex]] else { return arr }

		if fsection.header != nil {
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
		
		if fsection.footer != nil {
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
	
	override func createLayoutSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
		let id = sectionIds[sectionIndex]
		
		switch id {
			case SectionId.prefs.rawValue:
				return createLayoutPrefsSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
				
			case SectionId.address.rawValue:
				return createLayoutAddressSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
				
			default:
				return super.createLayoutSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		}
	}
	
	private func createLayoutPrefsSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
		guard let fsection = sectionsMap[sectionIds[sectionIndex]] else { return nil }
		let fieldsCount = fsection.fieldIds.count

		let aw = layoutEnvironment.container.contentSize.width
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
	
	private func createLayoutAddressSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		//	regular item
		let defitem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth( 1.0 ),
				heightDimension: .estimated(estimatedFieldHeight)
			)
		)
		
		//	postcode, country
		let postcodeitem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth( 1 / addressColumnSplit ),
				heightDimension: .estimated(estimatedFieldHeight)
			)
		)
		
		//	city
		let cityitem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth( min(1, 1 / addressColumnSplit * 2) ),
				heightDimension: .estimated(estimatedFieldHeight)
			)
		)
		
		let citygroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(estimatedFieldHeight)
			),
			subitems: [cityitem, postcodeitem, postcodeitem]	//	city, post code, country
		)
		
		let streetgroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(estimatedFieldHeight)
			),
			subitems: [defitem]
		)
		
		let addressgroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(estimatedFieldHeight * 2)
			),
			subitems: [streetgroup, citygroup]
		)
		
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(estimatedFieldHeight * (usePostalAsBillingAddress ? 3 : 5))
			),
			subitems: usePostalAsBillingAddress ? [addressgroup, defitem] : [addressgroup, defitem, addressgroup]
		)
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = layoutSectionSupplementaryItems(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		return section
	}
	
	override func populateSnapshot(flowIdentifier fid: String = UUID().uuidString) -> FieldsDataSource.Snapshot {
		var snapshot = Snapshot()
		
		for sectionId in sectionIds {
			guard let section = sectionsMap[sectionId] else { continue }
			
			snapshot.appendSections([sectionId])
			snapshot.appendItems(
				section.fieldIds,
				toSection: sectionId
			)
		}
		snapshot.reconfigureItems(Array(fieldsMap.keys))
		
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
		render(populateSnapshot(), animated: true)
	}
	
	func processBillingAddressToggle() {
		if usePostalAsBillingAddress {
			let a = user?.postalAddress
			user?.billingAddress = a
		} else {
			user?.billingAddress = nil
		}
		
		prepareFields()
		render(populateSnapshot(), animated: true)
	}
	
	//	MARK: Data source for the CV
	
	func prepareFields() {
		sectionIds.removeAll()
		sectionsMap.removeAll()
		fieldsMap.removeAll()
		
		var sections: [FieldSection] = []
		sections.append( buildAccountSection() )
		if shouldAddAddress {
			sections.append( buildAddressSection() )
		}
		sections.append( buildPrefsSection() )
		sections.append( buildPersonalSection() )
		sections.append( buildOtherSection() )
		
		sectionIds = sections.map { $0.id }
		sections.forEach { sectionsMap[$0.id] = $0 }
	}
	
	func buildAccountSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.account.rawValue,
			header: NSLocalizedString("Account information", comment: ""),
			footer: NSLocalizedString("Please use strong passwords. We encourage usage of password keepers and generators.", comment: "")
		)
		
		var fields: [FieldModel] = []
		
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
		
		fields.append({
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
		
		fields.forEach { fieldsMap[$0.id] = $0 }
		section.fieldIds = fields.map { $0.id }
		
		return section
	}
	
	func buildPersonTitleModel1() -> FieldModel {
		let model = PickerModel<PersonTitle>(
			id: FieldId.title.rawValue,
											 title: NSLocalizedString("Title", comment: ""),
											 value: user?.title,
											 values: PersonTitle.allCases,
											 valueFormatter: { return $0?.rawValue }
		)
		model.isPickerShown = isPersonTitlePickerExpanded
		model.displayPicker = {
			[unowned self] cell in
			if model.values.count == 0 { return }
			self.isPersonTitlePickerExpanded = !self.isPersonTitlePickerExpanded

			let fid = UUID().uuidString
			self.prepareFields()
			self.render(self.populateSnapshot(flowIdentifier: fid), animated: true)
		}
		model.selectedValueAtIndex = {
			[unowned self] selectedIndex, cell, shouldCollapse in
			if let selectedIndex {
				let c = model.values[selectedIndex]
				self.user?.title = c
			}
			if shouldCollapse {
				self.isPersonTitlePickerExpanded = false
			}
			
			let fid = UUID().uuidString
			self.prepareFields()
			self.render(self.populateSnapshot(flowIdentifier: fid), animated: true)
		}
		return model
	}
	
	func buildPersonalSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.personal.rawValue,
			header: NSLocalizedString("Personal information", comment: "")
		)
		
		var fields: [FieldModel] = []
		
		fields.append(
			buildPersonTitleModel1()
		)
		
		fields.append({
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
		
		fields.append({
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
		
		fields.append({
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
		
		fields.forEach { fieldsMap[$0.id] = $0 }
		section.fieldIds = fields.map { $0.id }
		
		return section
	}
	
	func buildAddressSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.address.rawValue,
			header: NSLocalizedString("Postal Address", comment: "")
		)
		
		var fields: [FieldModel] = []
		
		fields.append({
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
		
		fields.append({
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
		
		fields.append({
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
		
		fields.append({
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
		
		fields.append({
			let model = ToggleModel(id: FieldId.billingAddressToggle.rawValue, title: NSLocalizedString("Use as billing address?", comment: ""), value: usePostalAsBillingAddress)
			model.valueChanged = { [weak self] isOn, cell in
				//	required: update raw data
				self?.usePostalAsBillingAddress = isOn
			}
			return model
		}())
		
		if !usePostalAsBillingAddress {
			fields.append({
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
			
			fields.append({
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
			
			fields.append({
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
			
			fields.append({
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
		
		fields.append({
			let model = FormTextModel(
				id: FieldId.billingNote.rawValue,
				title: "",
				value: NSLocalizedString("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", comment: "")
			)
			model.customSetup = { label in
				label.textColor = .gray
				label.superview?.backgroundColor = .clear
			}
			return model
		}())
		
		fields.forEach { fieldsMap[$0.id] = $0 }
		section.fieldIds = fields.map { $0.id }
		
		return section
	}
	
	func buildOtherSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.other.rawValue,
			header: NSLocalizedString("Extra stuff", comment: "")
		)
		
		var fields: [FieldModel] = []
		
		fields.append({
			let model = TextViewModel(
				id: FieldId.note.rawValue,
				minimalHeight: 132,
				title: NSLocalizedString("Additional note", comment: ""),
				value: note
			)
			model.valueChanged = { [weak self] string, _ in
				self?.note = string
				model.value = string
			}
			return model
		}())
		
		fields.append({
			let model = FormButtonModel(
				id: FieldId.submit.rawValue,
				title: NSLocalizedString("Create account", comment: "")
			)
			return model
		}())
		
		fields.forEach { fieldsMap[$0.id] = $0 }
		section.fieldIds = fields.map { $0.id }
		
		return section
	}
	
	func buildPrefsSection() -> FieldSection {
		var section = FieldSection(
			id: SectionId.prefs.rawValue,
			header: NSLocalizedString("Preferred category", comment: "")
		)
		
		var fields: [FieldModel] = []
		
		for ic in inventoryCategories {
			fields.append(
				inventoryCategoryField(for: ic)
			)
		}
		
		fields.forEach { fieldsMap[$0.id] = $0 }
		section.fieldIds = fields.map { $0.id }
		
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
			self.render(self.populateSnapshot(), animated: false)
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
	func section(at index: Int) -> FieldSection? {
		guard let sectionIdentifier = gridSource.sectionIdentifier(for: index) else { return nil }
		return sectionsMap[sectionIdentifier]
	}
	
	func field(at indexPath: IndexPath) -> FieldId? {
		guard let itemIdentifier = gridSource.itemIdentifier(for: indexPath) else { return nil }
		return FieldId(rawValue: itemIdentifier)
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
