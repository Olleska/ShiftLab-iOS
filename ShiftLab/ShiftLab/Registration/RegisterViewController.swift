import UIKit

class RegistrationViewController: UIViewController {

    private let firstNameField: CustomComponent = {
        let field = CustomComponent()
        field.configure(title: "Имя", placeholder: "Введите имя", isSecure: false)
        return field
    }()
    private let lastNameField: CustomComponent = {
        let field = CustomComponent()
        field.configure(title: "Фамилия", placeholder: "Введите фамилию", isSecure: false)
        return field
    }()
    private let birthdayField: CustomComponent = {
        let field = CustomComponent()
        field.configure(title: "Дата рождения", placeholder: "Выберите дату", isSecure: false)
        return field
    }()
    private let passwordField: CustomComponent = {
        let field = CustomComponent()
        field.configure(title: "Пароль", placeholder: "Придумайте пароль", isSecure: true)
        return field
    }()
    private let confirmPasswordField: CustomComponent = {
        let field = CustomComponent()
        field.configure(title: "Подтверждение пароля", placeholder: "Повторите пароль", isSecure: true)
        return field
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()
        return picker
    }()
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.isEnabled = false
        return button
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        view.backgroundColor = .white
        setupLayout()
        setupDatePicker()
        setupActions()
    }
    private func setupLayout() {
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(birthdayField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(registerButton)
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            firstNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            firstNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 16),
            lastNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            lastNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            birthdayField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 16),
            birthdayField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            birthdayField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordField.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    private func setupDatePicker() {
        birthdayField.textField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dateDoneTapped))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        birthdayField.textField.inputAccessoryView = toolbar
    }
    private func setupActions() {
        [firstNameField, lastNameField, birthdayField, passwordField, confirmPasswordField].forEach { component in
            component.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    @objc private func dateDoneTapped() {
        birthdayField.textField.text = dateFormatter.string(from: datePicker.date)
        birthdayField.textField.resignFirstResponder()
        validateForm()
    }
    @objc private func textFieldDidChange() {
        validateForm()
    }
    @objc private func registerButtonTapped() {
        guard let name = firstNameField.textField.text else { return }
        UserDefaults.standard.set(name, forKey: "savedUserName")
        let mainVC = MainViewController()
        self.navigationController?.pushViewController(mainVC, animated: false)
    }
    private func validateForm() {
        let isFirstNameValid = !(firstNameField.textField.text?.isEmpty ?? true)
        let lastName = lastNameField.textField.text ?? ""
        let isLastNameValid = lastName.count >= 2
        let isBirthdayValid = !(birthdayField.textField.text?.isEmpty ?? true)
        let password = passwordField.textField.text ?? ""
        let passwordContainsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let passwordContainsUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let isPasswordValid = password.count >= 6 && passwordContainsNumber && passwordContainsUpper
        let confirmPassword = confirmPasswordField.textField.text ?? ""
        let isPasswordMatching = password == confirmPassword && !confirmPassword.isEmpty
        let isFormValid = isFirstNameValid && isLastNameValid && isBirthdayValid && isPasswordValid && isPasswordMatching
        registerButton.isEnabled = isFormValid
        registerButton.backgroundColor = isFormValid ? .systemBlue : .systemGray4
    }
}
