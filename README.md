![platforms: iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
[![](https://img.shields.io/github/license/radianttap/Fields.svg)](https://github.com/radianttap/Coordinator/blob/master/LICENSE)
![](https://img.shields.io/badge/swift-5+-223344.svg?logo=swift&labelColor=FA7343&logoColor=white)

# Fields v2

Good, solid base to build custom forms in iOS apps, using [Compositional Layout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout).

This is *not a library, nor framework*. It will never be a CocoaPod, Carthage or whatever package. Every form is different so you take this lot and adjust it to suit each specific case.

Each cell is self-sizing, implemented through [`FieldCell`](Fields/Cells/FieldCell.swift), which is base cell for all other specific cells. *It is expected that you use .xib for cell design and use qualified Auto Layout constraints so that self-sizing is possible.*

Each form field is implemented by pairing `Model` and `Cell` instance. Models are distinguished by `id` property; value of this property should be unique across all field. Easiest way to implement this is with `String` enum.

The most trivial cell model is `BasicModel`, which only has one property, previously mentioned `id`. All other models, have specific additional properties that directly map into cell display. Things like `title`, current field `value`, optional hints and error messages etc.

Model properties directly tie-in with Cell design and layout.

### Available Cells & Models

Each supported form field has a [reference Cell](Fields/Cells) implementation and its accompanying [ViewModel](Fields/CellModels).

* `FormTextCell` + `FormTextModel` – for static text, with support for multiple lines.
* `TextFieldCell` + `TextFieldModel` – classic text field input
* `TextViewCell` + `TextViewModel` – cell with internal `UITextView`, for large multi-line text
* `ToggleCell` + `ToggleModel` – for boolean flags
* `FormButtonCell` + `FormButtonModel` – models submit and other buttons
* `DatePickerCell` + `DatePickerModel` – shows `UIDatePicker` as “keyboard” for the field.
* `PickerCell` + `PickerModel` – when you need to show a larger set of items and allow customer to choose one. It has a reference option cell implementation, custom UIVC and DataProvider types.
* `SegmentsCell` + `PickerModel` - when you only have few options to choose from and want to display them using `UISegmentedControl`.

### Sections

Fields can be grouped into `FieldSection` arrays, where each section is defined by custom String `id` and a set of accompanying fields.

You can also specify custom header and footer text for the section and adjust their design + model, as you see fit.

Both of these are subclasses of [`FieldSupplementaryView`](Fields/Cells/FieldSupplementaryView.swift) which implements self-sizing support.

### Controllers

The base UIVC class is `FieldsController`, which you can use **if** you want to manually add the fields inside, say `UIScrollView`, instead of using Collection View. 

(Example: ForgotPass screen in the demo app)

Its subclass, `FieldsCollectionController`, is much more interesting as it builds an UICV instance to which you will add your cells.

(Examples: Login and Register screens in the demo app)

Both controllers expose 3 methods you can call from your data source objects:

`renderContentUpdates()` – you should call this when your form model is updated and you need to re-render the form. In the `FieldsController` this does nothing. In `FieldsCollectionController` it calls `collectionView.reloadData`.

`keyboardWillShow(notification:)` – when field input view shows up.

`keyboardWillHide(notification)` – when field resigns its input view (keyboard).

When you override these methods, you most likely *don’t want* to call `super`.

## Usage

> The best way is learn how it works is to look at the demo app. It has 3 different forms and they illustrate typical uses.

For each form, you should subclass one of the said two controllers, then add another class which will act as DataSource for it.

For example, `LoginController` in the demo app subclasses `FieldsCollectionController`. It uses `LoginDataSource` as the `UICollectionViewDataSource`.

For the minimal setup, you don’t need to use sections, you can use just fields. Thus all you need is an array of `[FieldModel]` instances + a declaration of unique `id` values for each field. An enum is just fine:

```swift
enum FieldId: String {
	case info
	case username
	case password
	case forgotpassword
	case submit
}
```

Now, you populate `fields` array with specific Model instance for those fields. Here’s an example of TextFieldModel:

```swift
let model = TextFieldModel(id: FieldId.username.rawValue,
						   title: NSLocalizedString("Username", comment: ""),
						   value: user?.username)
model.customSetup = { textField in
	textField.textContentType = .username
}
model.valueChanged = { 
	[weak self] string, _ in
	
	self?.user?.username = string
	model.value = string
}
```

This illustrates general idea: 

1. Setup basic stuff, like title of the field and current value to show.
2. Specify custom design and behavior – in this case just the `UITextField` is exposed but you can alter this into whatever you want to expose.
3. Specify handler which is called from the `TextFieldCell`, when the value editing is done. This closure updates actual model objects of your app (like `User`).

`User` is actual data model type you use in the app. `TextFieldModel` is _ViewModel_ derivative of `User`, custom tailored for the `TextFieldCell`.

### Boilerplate stuff

The rest of the LoginDataSource is simply an implementation of the UICVDataSource. 

The most important aspect is the `prepareView()` method which register UICVCell types for each `FieldId` value. *This effectively disables cell reusability!* Each field you have will likely have custom stuff and setup, thus you don’t want to reuse neither of them, since that leads to problems. Forms generally are not big, a dozen or so fields at most, thus this is not an issue from the memory side.

The rest of the file is just boilerplate UICVDataSource delegate methods.

### Layout

By default, each field will use entire width of the UICV and height will be calculated per content.

## License

[MIT](https://choosealicense.com/licenses/mit/), as usual.

## v1

Previous version, using custom `UICollectionViewLayout` subclass is tagged with `v1.0` in source code.

## Give back

If you found this code useful, please consider [buying me a coffee](https://www.buymeacoffee.com/radianttap) or two. ☕️😋
