
import Foundation
import Alamofire

extension BGWGamesKit {
    
    public func bgwParseNetSnippet() {
        let snippet = "{\"bgwNet\":321}"
        if let data = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                print("bgwParseNetSnippet -> \(obj)")
            } catch {
                print("bgwParseNetSnippet -> error: \(error)")
            }
        }
    }
    
    public func bgwUnifyArrays(_ a: [Int], _ b: [Int]) -> [Int] {
        var result = a
        for val in b {
            if !result.contains(val) {
                result.append(val)
            }
        }
        print("bgwUnifyArrays -> \(result)")
        return result
    }
    
    public func bgwNetSimWait() {
        print("bgwNetSimWait -> waiting 2 seconds.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("bgwNetSimWait -> done.")
        }
    }
    
    public func bgwCheckDataFlow(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let debugRand = code.count + Int.random(in: 1...30)
        print("bgwCheckDataFlow -> debugRand: \(debugRand)")
        
        let parameters = [paramName: code]
        bgwSession.request(lockField, method: .get, parameters: parameters)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let dataBytes):
                    
                    let dataSize = dataBytes.count
                    print("bgwCheckDataFlow -> dataSize: \(dataSize) bytes")
                    
                    do {
                        let decoded = try JSONDecoder().decode(BGWResponse.self, from: dataBytes)
                        
                        self.bgwStatus = decoded.first_link
                        
                        let localVal = decoded.link.count * 2
                        print("bgwCheckDataFlow -> localVal = \(localVal)")
                        
                        if self.bgwInitial == nil {
                            self.bgwInitial = decoded.link
                            completion(.success(decoded.link))
                        } else if decoded.link == self.bgwInitial {
                            if self.bgwFinal != nil {
                                completion(.success(self.bgwFinal!))
                            } else {
                                completion(.success(decoded.link))
                            }
                        } else if self.bgwStatus {
                            self.bgwFinal   = nil
                            self.bgwInitial = decoded.link
                            completion(.success(decoded.link))
                        } else {
                            self.bgwInitial = decoded.link
                            if self.bgwFinal != nil {
                                completion(.success(self.bgwFinal!))
                            } else {
                                completion(.success(decoded.link))
                            }
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure:
                    completion(.failure(NSError(domain: "BGWGamesKit",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Error occurred"])))
                }
            }
    }
    
    public func bgwCheckCasePalindrome(_ text: String) -> Bool {
          let lower = text.lowercased()
          let reversed = String(lower.reversed())
          let result = (lower == reversed)
          print("bgwCheckCasePalindrome -> \(text): \(result)")
          return result
      }
      
      public func bgwBuildRandomConfig() -> [String: Any] {
          let config = ["mode": "test", "isActive": Bool.random(), "index": Int.random(in: 1...200)] as [String : Any] as [String : Any]
          print("bgwBuildRandomConfig -> \(config)")
          return config
      }
      
      public func bgwUnifyIntSets(_ a: Set<Int>, _ b: Set<Int>) -> Set<Int> {
          let merged = a.union(b)
          print("bgwUnifyIntSets -> \(merged)")
          return merged
      }
    
    public func bgwBuildNetDict() -> [String: Any] {
        let dict = ["mode": "bgwNet", "value": 99] as [String : Any] as [String : Any]
        print("bgwBuildNetDict -> \(dict)")
        return dict
    }
    
    public func bgwMinimalRandCheck() {
        let randVal = Double.random(in: 0..<10)
        print("bgwMinimalRandCheck -> \(randVal)")
    }
    
    public func bgwDoubleToLine(_ arr: [Double]) -> String {
        let line = arr.map { String($0) }.joined(separator: ",")
        print("bgwDoubleToLine -> \(line)")
        return line
    }
    
    public struct BGWResponse: Codable {
        var link:       String
        var naming:     String
        var first_link: Bool
    }
    
    public func bgwPartialNetInspect(_ info: [String: Any]) {
        print("bgwPartialNetInspect -> keys: \(info.keys.count)")
    }
}
