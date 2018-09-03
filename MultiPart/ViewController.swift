//
//  ViewController.swift
//  MultiPart
//
//  Created by apple on 9/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

typealias parameters = [String:String]

class ViewController: UIViewController {
    
    @IBAction func btn_onGetTapped(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        var request = URLRequest(url: url)
        let boundary = generateBoundary()
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let databody = createDataBody(withParameters: nil, media: nil, boundary: boundary)
        request.httpBody = databody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
               print(response)
            }
            if let data = data {
                do{
                   let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    @IBAction func btn_onPostTapped(_ sender: Any) {
        // testimage
        let parameters = ["name":"MyTestFile111","description":"seshu practice test file"]
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "suri"), forKey: "image") else {
            return
        }
        
        
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        let boundary = generateBoundary()
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID d5d4b98a07e38c8", forHTTPHeaderField: "Authorization")
        let databody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = databody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch {
                    print(error)
                }
            }
            }.resume()
        
        
    }
    
    func generateBoundary() -> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    func createDataBody(withParameters params:parameters?,media:[Media]?,boundary : String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params{
            for (key,value) in parameters{
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
            if let media = media {
                for photo in media{
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type:\(photo.mimeType + lineBreak + lineBreak)")
                    body.append(photo.data)
                    body.append(lineBreak)
                }
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension Data{
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

