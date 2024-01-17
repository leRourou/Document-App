//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Adrien CHENU on 1/17/24.
//

import UIKit
import QuickLook

extension Int{
    func formattedSize() -> String{
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: ByteCountFormatter.CountStyle.decimal)
    }
}

class DocumentTableViewController: UITableViewController {
    let quickLookController = QLPreviewController()

    struct DocumentFile{
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
    }

    func listFileInBundle() -> [DocumentFile] {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        var documentListBundle = [DocumentFile]()
    
        for item in items {
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                let currentUrl = URL(fileURLWithPath: path + "/" + item)
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                documentListBundle.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description)
                )
            }
        }
        return documentListBundle
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        quickLookController.dataSource = self;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFileInBundle().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = listFileInBundle()[indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = listFileInBundle()[indexPath.row].url
        self.instantiateQLPreviewController(withUrl: file)
    }
    
    func instantiateQLPreviewController(withUrl url: URL) {
        quickLookController.currentPreviewItemIndex = 0
        present(quickLookController, animated: true, completion: nil)
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let file = listFileInBundle()[index]
        return file.url as QLPreviewItem
    }
}
