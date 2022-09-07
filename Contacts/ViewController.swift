//
//  ViewController.swift
//  Contacts
//
//  Created by Alexander Zub on 06.09.2022.
//

import UIKit

class ViewController: UIViewController {
    private var contacts = [ContactProtocol]()
    
    private func loadContacts() {
        contacts.append(Contact(title: "Александр Витальевич", phone: "+79257644244"))
        contacts.append(Contact(title: "Георгий Алексеевич", phone: "+78887776655"))
        contacts.append(Contact(title: "Воронин Сергей", phone: "+79999999999"))
        contacts.sort{ $0.title < $1.title }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    // Переиспользование ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell =  tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
            return cell
    }
    // Добавлена проверка версии ОС с целью правильного формирования ячейки
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        if #available(iOS 14, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = contacts[indexPath.row].title
            configuration.secondaryText = contacts[indexPath.row].phone
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = "Cтрока \(indexPath.row)"
        }
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
