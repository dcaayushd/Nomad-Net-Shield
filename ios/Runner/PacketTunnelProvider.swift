import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "YOUR_VPN_SERVER_ADDRESS")
        networkSettings.ipv4Settings = NEIPv4Settings(addresses: ["192.168.1.1"], subnetMasks: ["255.255.255.0"])
        networkSettings.ipv4Settings?.includedRoutes = [NEIPv4Route.default()]
        networkSettings.dnsSettings = NEDNSSettings(servers: ["8.8.8.8", "8.8.4.4"])

        setTunnelNetworkSettings(networkSettings) { error in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}