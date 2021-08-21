//
//  UpdateViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/8/20.
//

import Cocoa
import Alamofire

class UpdateViewController: NSViewController {

    public var updateBean: UpdateBean?
    
    @IBOutlet var summaryTextView: NSTextView!
    @IBAction func confirmAction(_ sender: NSButton) {
        guard let url = updateBean?.url else {
            dismiss(self)
            return
        }
//        let dest: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("sp.dmg")
//            print(fileURL)
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        Alamofire.download(url, to: dest)
//            .downloadProgress { (progress) in
//            print("progress = \(progress)")
//        }
//            .responseData { (response) in
//                print(response)
//            }
        NSWorkspace.shared.open(URL.init(string: url)!)
        dismiss(self)
    }
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        summaryTextView.string = updateBean?.summary ?? ""
    }
    
}
