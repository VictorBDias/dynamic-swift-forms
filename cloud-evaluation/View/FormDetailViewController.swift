//
//  FormDetailViewController.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//

import UIKit

class FormDetailViewController: UIViewController {
    var form: FormEntity?
    private var viewModel = FormDetailViewModel()
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = form?.title
        setupUI()
        viewModel.loadFormFields(for: form!)
        renderFields()
    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
    }

    func renderFields() {
        for field in viewModel.fields {
            let label = UILabel()
            label.text = field.label
            stackView.addArrangedSubview(label)
            
            switch field.type {
            case "text", "number":
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                stackView.addArrangedSubview(textField)
            case "dropdown":
                let pickerView = UIPickerView()
                stackView.addArrangedSubview(pickerView)
            case "description":
                let label = UILabel()
                label.text = field.label
                stackView.addArrangedSubview(label)
            default:
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                stackView.addArrangedSubview(textField)
            }
        }
    }
}
