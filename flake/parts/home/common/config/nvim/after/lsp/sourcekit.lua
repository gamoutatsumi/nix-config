return {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
    cmd = {
        "xcrun",
        "sourcekit-lsp",
        "-Xswiftc",
        "-sdk",
        "-Xswiftc",
        vim.fn.trim(vim.fn.system("xcrun --show-sdk-path --sdk iphonesimulator")),
        "-Xswiftc",
        "-target",
        "-Xswiftc",
        "arm64-apple-ios17.5-simulator",
    },
}
