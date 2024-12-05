class DNSOverHTTPSConfiguration {
    static let providers: [String: DNSProviderConfig] = [
        "CloudFlare": .cloudflare,
        "Google": .google,
        "AdGuard": .adGuard,
        "Quad9": .quad9,
        "AliDNS": .aliDNS,
        "DNSPod": .dnsPod,
        "threeSixty": .threeSixty,
        "Quad101": .quad101,
        "Mullvad": .mullvad,
        "ControlD": .controlD,
        "Najalla": .najalla,
        "SheCan": .sheCan
    ]
    
    struct DNSProviderConfig {
        let url: URL
        let bootstrapHosts: [String]
    }
}

extension DNSOverHTTPSConfiguration.DNSProviderConfig {
    static let cloudflare = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://cloudflare-dns.com/dns-query")!,
        bootstrapHosts: [
            "162.159.36.1",
            "162.159.46.1",
            "1.1.1.1",
            "1.0.0.1",
            "162.159.132.53",
            "2606:4700:4700::1111",
            "2606:4700:4700::1001",
            "2606:4700:4700::0064",
            "2606:4700:4700::6400"
        ]
    )
    
    static let google = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.google/resolve")!,
        bootstrapHosts: [
            "8.8.8.8",
            "8.8.4.4",
            "2001:4860:4860::8888",
            "2001:4860:4860::8844"
        ]
    )
    
    static let adGuard = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.adguard.com/dns-query")!,
        bootstrapHosts: [
            "94.140.14.140",
            "94.140.14.141",
            "2a10:50c0::1:ff",
            "2a10:50c0::2:ff"
        ]
    )
    
    // Add more provider configurations similarly
    static let quad9 = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.quad9.net/dns-query")!,
        bootstrapHosts: [
            "9.9.9.9",
            "149.112.112.112",
            "2620:fe::fe",
            "2620:fe::9"
        ]
    )
    
    // Placeholder implementations for other providers
    static let aliDNS = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.alidns.com/resolve")!,
        bootstrapHosts: ["223.5.5.5", "223.6.6.6", "2400:3200::1", "2400:3200:baba::1"]
    )
    
    static let dnsPod = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://doh.pub/dns-query")!,
        bootstrapHosts: ["1.12.12.12", "120.53.53.53"]
    )
    
    static let threeSixty = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://doh.360.cn/dns-query")!,
        bootstrapHosts: ["101.226.4.6", "218.30.118.6", "123.125.81.6", "140.207.198.6", "180.163.249.75", "101.199.113.208", "36.99.170.86"]
    )
    
    static let quad101 = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.101.net/dns-query")!,
        bootstrapHosts: ["101.101.101.101", "2001:de4::101", "2001:de4::102"]
    )
    
    static let mullvad = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://doh.mullvad.net/dns-query")!,
        bootstrapHosts: ["194.242.2.2", "193.19.108.2", "2a07:e340::2"]
    )
    
    static let controlD = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.controld.com/dns-query")!,
        bootstrapHosts: ["76.76.2.0", "76.76.10.0", "2606:1a40::", "2606:1a40:1::"]
    )
    
    static let najalla = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://dns.najalla.net/dns-query")!,
        bootstrapHosts: ["95.215.19.53", "2001:67c:2354:2::53"]
    )
    
    static let sheCan = DNSOverHTTPSConfiguration.DNSProviderConfig(
        url: URL(string: "https://shecan.ir/dns-query")!,
        bootstrapHosts: ["178.22.122.100", "185.51.200.2"]
    )
}