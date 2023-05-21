module.exports = {
    networks: {
        development: {
            host: "127.0.0.1", port: 9545, network_id: "5777"
        }
    },
    compilers: {
        solc: {
            settings: {
                optimizer: {
                    enabled: true, // Default: false
                    runs: 200      // Default: 200
                }
            }
        }
    }
};
