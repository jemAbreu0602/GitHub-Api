//
//  AESManager.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/19/25.
//

import CryptoSwift

class AESManager {
    static let shared = AESManager()
    private let secretKey: String =  "VufXTAcJje7pXtb2";

    func encrypt(_ input: String) throws -> String? {
        guard
            let data = input.data(using: .utf8),
            let encrypted = try? AES(key: Array(secretKey.utf8),
                                     blockMode: CBC.init(iv: Array(secretKey.utf8)),
                                     padding: .pkcs7).encrypt([UInt8](data))
        else {
            return nil
        }

        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }

    func decrypt(_ input: String) throws -> String? {
        guard
            let data = Data(base64Encoded: input),
            let decrypted = try? AES(key: Array(secretKey.utf8),
                                     blockMode: CBC.init(iv: Array(secretKey.utf8)),
                                     padding: .pkcs7).decrypt([UInt8](data))
        else {
            return nil
        }

        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8)
        
    }
}
