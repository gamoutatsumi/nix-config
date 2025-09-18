-- NVUI固有の設定。NVUIを使用していない場合はこのファイルは不要かもしれません。
if vim.g.nvui then
    vim.opt.runtimepath:append("/usr/share/nvui/vim")
    vim.opt.guifont = "PlemolJP Console NF"
    vim.fn.rpcnotify(1, "NVUI_ANIMATIONS_ENABLED", false)
end
