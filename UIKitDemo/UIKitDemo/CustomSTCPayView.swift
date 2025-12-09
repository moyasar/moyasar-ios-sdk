//
//  CustomSTCPayView-UIKitDemo.swift
//  UIKitDemo
//
//  Created by Mahmoud Abdelwahab on 09/12/2025.
//

import UIKit
import MoyasarSdk

final class MyCustomSTCPayViewController: UIViewController, UITextFieldDelegate {
    private let viewModel: STCPayViewModel

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Phone step
    private let phoneContainer = UIStackView()
    private let phoneTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Mobile Number"
        l.font = .preferredFont(forTextStyle: .headline)
        return l
    }()
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.placeholder = "05XXXXXXXX"
        return tf
    }()
    private let phoneErrorLabel: UILabel = {
        let l = UILabel()
        l.text = "Invalid phone number"
        l.textColor = .systemRed
        l.font = .preferredFont(forTextStyle: .footnote)
        l.isHidden = true
        return l
    }()
    private let payButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Pay", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return b
    }()

    // OTP step
    private let otpContainer = UIStackView()
    private let otpTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Enter OTP"
        l.font = .preferredFont(forTextStyle: .headline)
        return l
    }()
    private let otpTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.placeholder = "XXXXXX"
        return tf
    }()
    private let otpErrorLabel: UILabel = {
        let l = UILabel()
        l.text = "Invalid OTP"
        l.textColor = .systemRed
        l.font = .preferredFont(forTextStyle: .footnote)
        l.isHidden = true
        return l
    }()
    private let confirmButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Confirm", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return b
    }()

    // Activity indicator
    private let spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .medium)
        s.hidesWhenStopped = true
        return s
    }()

    // MARK: - Init
    init(paymentRequest: PaymentRequest, callback: @escaping STCResultCallback) {
        self.viewModel = STCPayViewModel(paymentRequest: paymentRequest, resultCallback: callback)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Custom STC Pay"
        setupLayout()
        wireActions()
        render()
    }

    // MARK: - Setup
    private func setupLayout() {
        // Scroll + content
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Containers
        phoneContainer.axis = .vertical
        phoneContainer.spacing = 12
        phoneContainer.translatesAutoresizingMaskIntoConstraints = false

        otpContainer.axis = .vertical
        otpContainer.spacing = 12
        otpContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(phoneContainer)
        contentView.addSubview(otpContainer)

        // Phone subviews
        phoneContainer.addArrangedSubview(phoneTitleLabel)
        phoneContainer.addArrangedSubview(phoneTextField)
        phoneContainer.addArrangedSubview(phoneErrorLabel)
        phoneContainer.addArrangedSubview(payButton)

        // OTP subviews
        otpContainer.addArrangedSubview(otpTitleLabel)
        otpContainer.addArrangedSubview(otpTextField)
        otpContainer.addArrangedSubview(otpErrorLabel)
        otpContainer.addArrangedSubview(confirmButton)

        NSLayoutConstraint.activate([
            phoneContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            phoneContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            phoneContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            otpContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            otpContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            otpContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            otpContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        // Spinner in nav bar
        let spinnerItem = UIBarButtonItem(customView: spinner)
        navigationItem.rightBarButtonItem = spinnerItem
    }

    private func wireActions() {
        phoneTextField.addTarget(self, action: #selector(phoneChanged), for: .editingChanged)
        otpTextField.addTarget(self, action: #selector(otpChanged), for: .editingChanged)
        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        phoneTextField.delegate = self
        otpTextField.delegate = self
    }

    // MARK: - Actions
    @objc private func phoneChanged() {
        let formatted = localFormatPhone(phoneTextField.text ?? "")
        if phoneTextField.text != formatted { phoneTextField.text = formatted }
        viewModel.mobileNumber = formatted
        updatePhoneValidityUI()
    }

    @objc private func otpChanged() {
        viewModel.otp = otpTextField.text ?? ""
        updateOtpValidityUI()
    }

    @objc private func payTapped() {
        Task { @MainActor in
            setLoading(true)
            await viewModel.initiatePayment()
            setLoading(false)
            render()
        }
    }

    @objc private func confirmTapped() {
        Task { @MainActor in
            setLoading(true)
            await viewModel.submitOtp()
            setLoading(false)
            render()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Rendering
    private func render() {
        // Toggle containers based on screen step
        switch viewModel.screenStep {
        case .mobileNumber:
            phoneContainer.isHidden = false
            otpContainer.isHidden = true
        case .otp:
            phoneContainer.isHidden = true
            otpContainer.isHidden = false
        }
        // Sync text fields with model
        phoneTextField.text = viewModel.mobileNumber
        otpTextField.text = viewModel.otp
        updatePhoneValidityUI()
        updateOtpValidityUI()
    }

    private func updatePhoneValidityUI() {
        let text = phoneTextField.text ?? ""
        let digits = text.filter { $0.isNumber }
        // Valid if exactly 10 digits and starts with 05
        let valid = digits.count == 10 && text.hasPrefix("05")
        phoneErrorLabel.isHidden = valid || !viewModel.showErrorHintView.value
        payButton.isEnabled = valid && !viewModel.isLoading
        payButton.alpha = payButton.isEnabled ? 1.0 : 0.5
    }

    private func updateOtpValidityUI() {
        let valid = viewModel.isValidOtp
        otpErrorLabel.isHidden = valid || !viewModel.showErrorHintView.value
        confirmButton.isEnabled = valid && !viewModel.isLoading
        confirmButton.alpha = confirmButton.isEnabled ? 1.0 : 0.5
    }

    private func setLoading(_ loading: Bool) {
        if loading { spinner.startAnimating() } else { spinner.stopAnimating() }
        payButton.isEnabled = !loading && viewModel.isValidPhoneNumber
        confirmButton.isEnabled = !loading && viewModel.isValidOtp
        payButton.setTitle(loading && viewModel.screenStep == .mobileNumber ? "Loading…" : "Pay", for: .normal)
        confirmButton.setTitle(loading && viewModel.screenStep == .otp ? "Loading…" : "Confirm", for: .normal)
        payButton.alpha = payButton.isEnabled ? 1.0 : 0.5
        confirmButton.alpha = confirmButton.isEnabled ? 1.0 : 0.5
    }
}

// MARK: - Helpers
/// Local phone formatter: keep digits only, normalize to start with 05, and hard-limit to 10 digits total
private func localFormatPhone(_ input: String) -> String {
    let rawDigits = input.filter { $0.isNumber }
    if rawDigits.isEmpty { return "" }
    let tail: String
    if rawDigits.hasPrefix("05") {
        tail = String(rawDigits.dropFirst(2))
    } else if rawDigits.hasPrefix("5") {
        tail = String(rawDigits.dropFirst(1))
    } else if rawDigits.hasPrefix("0") {
        tail = String(rawDigits.dropFirst(1))
    } else {
        tail = rawDigits
    }
    let normalized = "05" + String(tail.prefix(8))
    return normalized
}

extension MyCustomSTCPayViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Always allow deletion
        if string.isEmpty { return true }

        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        let proposed = currentText.replacingCharacters(in: range, with: string)

        if textField === phoneTextField {
            // Normalize and enforce max 10 digits total ("05" + 8 digits)
            let formatted = localFormatPhone(proposed)
            let digitsCount = formatted.filter { $0.isNumber }.count
            if digitsCount > 10 { return false }
            // Apply normalized text immediately to keep prefix and trimming consistent
            textField.text = formatted
            viewModel.mobileNumber = formatted
            updatePhoneValidityUI()
            return false
        } else if textField === otpTextField {
            // Allow digits only, max 6
            let onlyDigits = proposed.filter { $0.isNumber }
            if onlyDigits.count > 6 { return false }
            return onlyDigits == proposed
        }
        return true
    }
}
