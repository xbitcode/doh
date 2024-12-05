import Foundation
import Network
import DNSOverHTTPSConfiguration



class ApiClient {
    private let dohConfig: DNSOverHTTPSConfiguration.DNSProviderConfig
    private let session: URLSession
    
    init(dohProvider: String) {
        // Default to CloudFlare if provider not found
        self.dohConfig = DNSOverHTTPSConfiguration.providers[dohProvider] ?? .cloudflare
        
        let config = URLSessionConfiguration.ephemeral
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpAdditionalHeaders = ["Accept": "application/dns-json"]
        
        // Configure DNS resolution
        config.dnsServers = self.dohConfig.bootstrapHosts
        
        self.session = URLSession(configuration: config)
    }
    
    func makeRequest(
        method: String, 
        url: String, 
        headers: [String: String] = [:], 
        body: String? = nil, 
        completion: @escaping (String?, Error?) -> Void
    ) {
        guard let requestUrl = URL(string: url) else {
            completion(nil, NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add request body for methods that support it
        if let body = body, 
           ["POST", "PUT", "PATCH"].contains(method.uppercased()) {
            request.httpBody = body.data(using: .utf8)
            
            // Set default content type if not provided
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for network errors
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Check for HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NSError(domain: "APIError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"]))
                return
            }
            
            // Check response status
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "HTTP Error \(httpResponse.statusCode)",
                    "responseBody": String(data: data ?? Data(), encoding: .utf8) ?? ""
                ]))
                return
            }
            
            // Convert response data to string
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(nil, NSError(domain: "APIError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Unable to parse response"]))
                return
            }
            
            completion(responseString, nil)
        }
        task.resume()
    }
    
    // Convenience methods for each HTTP method
    func makeGetRequest(url: String, headers: [String: String] = [:], completion: @escaping (String?, Error?) -> Void) {
        makeRequest(method: "GET", url: url, headers: headers, completion: completion)
    }
    
    func makePostRequest(url: String, headers: [String: String] = [:], body: String? = nil, completion: @escaping (String?, Error?) -> Void) {
        makeRequest(method: "POST", url: url, headers: headers, body: body, completion: completion)
    }
    
    func makePutRequest(url: String, headers: [String: String] = [:], body: String? = nil, completion: @escaping (String?, Error?) -> Void) {
        makeRequest(method: "PUT", url: url, headers: headers, body: body, completion: completion)
    }
    
    func makePatchRequest(url: String, headers: [String: String] = [:], body: String? = nil, completion: @escaping (String?, Error?) -> Void) {
        makeRequest(method: "PATCH", url: url, headers: headers, body: body, completion: completion)
    }
    
    func makeDeleteRequest(url: String, headers: [String: String] = [:], body: String? = nil, completion: @escaping (String?, Error?) -> Void) {
        makeRequest(method: "DELETE", url: url, headers: headers, body: body, completion: completion)
    }
}

public class DohApiClientPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "doh_api_client", binaryMessenger: registrar.messenger())
        let instance = DohApiClientPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    
    case "makeGetRequest":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let dohProvider = args["dohProvider"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", 
                                message: "URL and DoH provider are required", 
                                details: nil))
            return
        }
        
        let headers = args["headers"] as? [String: String] ?? [:]
        
        ApiClient(dohProvider: dohProvider).makeGetRequest(url: url, headers: headers) { response, error in
            if let error = error {
                result(FlutterError(code: "GET_API_ERROR", 
                                    message: error.localizedDescription, 
                                    details: nil))
            } else {
                result(response)
            }
        }
    
    case "makePostRequest":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let dohProvider = args["dohProvider"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", 
                                message: "URL and DoH provider are required", 
                                details: nil))
            return
        }
        
        let headers = args["headers"] as? [String: String] ?? [:]
        let body = args["body"] as? String
        
        ApiClient(dohProvider: dohProvider).makePostRequest(url: url, headers: headers, body: body) { response, error in
            if let error = error {
                result(FlutterError(code: "POST_API_ERROR", 
                                    message: error.localizedDescription, 
                                    details: nil))
            } else {
                result(response)
            }
        }
    
    case "makePutRequest":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let dohProvider = args["dohProvider"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", 
                                message: "URL and DoH provider are required", 
                                details: nil))
            return
        }
        
        let headers = args["headers"] as? [String: String] ?? [:]
        let body = args["body"] as? String
        
        ApiClient(dohProvider: dohProvider).makePutRequest(url: url, headers: headers, body: body) { response, error in
            if let error = error {
                result(FlutterError(code: "PUT_API_ERROR", 
                                    message: error.localizedDescription, 
                                    details: nil))
            } else {
                result(response)
            }
        }
    
    case "makePatchRequest":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let dohProvider = args["dohProvider"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", 
                                message: "URL and DoH provider are required", 
                                details: nil))
            return
        }
        
        let headers = args["headers"] as? [String: String] ?? [:]
        let body = args["body"] as? String
        
        ApiClient(dohProvider: dohProvider).makePatchRequest(url: url, headers: headers, body: body) { response, error in
            if let error = error {
                result(FlutterError(code: "PATCH_API_ERROR", 
                                    message: error.localizedDescription, 
                                    details: nil))
            } else {
                result(response)
            }
        }
    
    case "makeDeleteRequest":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let dohProvider = args["dohProvider"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", 
                                message: "URL and DoH provider are required", 
                                details: nil))
            return
        }
        
        let headers = args["headers"] as? [String: String] ?? [:]
        let body = args["body"] as? String
        
        ApiClient(dohProvider: dohProvider).makeDeleteRequest(url: url, headers: headers, body: body) { response, error in
            if let error = error {
                result(FlutterError(code: "DELETE_API_ERROR", 
                                    message: error.localizedDescription, 
                                    details: nil))
            } else {
                result(response)
            }
        }
    
    default:
        result(FlutterMethodNotImplemented)
    }
}
}