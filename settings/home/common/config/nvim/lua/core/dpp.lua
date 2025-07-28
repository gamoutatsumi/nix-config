local M = {}

local function notify_info(msg)
    vim.notify(msg, vim.log.levels.INFO, { title = "DPP" })
end

local function notify_warn(msg)
    vim.notify(msg, vim.log.levels.WARN, { title = "DPP" })
end

function M.setup()
    local dpp_dir = vim.fn.stdpath("data") .. "/dpp"
    vim.g["denops#deno"] = "@deno@" -- This placeholder is expected to be replaced by your build system (e.g., home-manager)
    vim.g["denops#server#deno_args"] = { "-q", "--no-lock", "--unstable-kv", "--unstable-ffi", "-A" }
    vim.api.nvim_create_augroup("MyAutoCmd", {})

    local function init_plugin(plugin_repo)
        local dir = dpp_dir .. "/repos/github.com/" .. plugin_repo
        if vim.fn.isdirectory(dir) == 0 then
            notify_info("Cloning " .. plugin_repo .. " to " .. dir)
            -- Synchronously clone, similar to the original dpp.vim behavior.
            -- This might block Neovim startup if the plugin is not already present.
            -- Consider pre-cloning these core plugins or using an async method if startup time is critical.
            local clone_cmd =
                string.format("git clone --filter=blob:none --depth 1 https://github.com/%s %s", plugin_repo, dir)
            local result = vim.fn.system(clone_cmd)
            if vim.v.shell_error ~= 0 then
                notify_warn(string.format("Failed to clone %s. Output: %s", plugin_repo, result))
                return false -- Indicate failure
            else
                notify_info(plugin_repo .. " cloned successfully.")
            end
        end
        vim.opt.runtimepath:prepend(vim.fn.fnamemodify(dir, ":p"):gsub("[/\\]$", ""))
        return true -- Indicate success
    end

    local dpp_config_file = vim.fn.stdpath("config") .. "/dpp.ts"

    local function dpp_make_state()
        vim.fn["dpp#make_state"](dpp_dir, dpp_config_file)
    end

    -- Initialize dpp.vim, dpp-ext-lazy, and the theme first.
    -- These are needed before dpp can load the main configuration (dpp.ts).
    if not init_plugin("Shougo/dpp.vim") then
        notify_warn("Failed to initialize Shougo/dpp.vim. DPP might not work.")
        return
    end
    init_plugin("Shougo/dpp-ext-lazy")
    init_plugin("tani/vim-artemis") -- Theme, loaded early

    -- Try to load the dpp state.
    if vim.fn["dpp#min#load_state"](dpp_dir) == 0 then
    else
        -- Failed to load state. Load essential extensions and then make the state.
        notify_warn("dpp load_state() failed. Initializing essential extensions and making state.")

        local essential_plugins = {
            "Shougo/dpp-ext-installer",
            "Shougo/dpp-ext-local",
            "Shougo/dpp-ext-toml",
            "Shougo/dpp-ext-packspec",
            "Shougo/dpp-protocol-git",
            "vim-denops/denops.vim", -- Denops is crucial
        }

        for _, plugin_repo in ipairs(essential_plugins) do
            init_plugin(plugin_repo)
        end

        -- If Neovim, run denops plugin scripts. This is important after denops.vim is on runtimepath.
        if vim.fn.has("nvim") == 1 then
            vim.cmd("runtime! plugin/denops.vim")
        end

        -- Once Denops is ready, try to make the dpp state.
        vim.api.nvim_create_autocmd("User", {
            group = "MyAutoCmd",
            pattern = "DenopsReady",
            callback = function()
                notify_warn("DenopsReady: dpp load_state() had failed, calling dpp_make_state().")
                dpp_make_state()
            end,
            -- `once = true` might be suitable if DenopsReady fires multiple times,
            -- but original dpp.vim didn't have `++once`.
            -- Given `autocmd!` in init.vim, this autocmd is set up once per session.
        })
    end

    -- Notification for when dpp state creation is complete.
    vim.api.nvim_create_autocmd("User", {
        group = "MyAutoCmd",
        pattern = "Dpp:makeStatePost",
        callback = function()
            notify_info("dpp make_state() is done.")
        end,
    })

    -- User commands for dpp operations.
    vim.api.nvim_create_user_command("DppUpdate", function()
        vim.fn["dpp#async_ext_action"]("installer", "checkNotUpdated")
    end, {})
    vim.api.nvim_create_user_command("DppUpdateAll", function()
        vim.fn["dpp#async_ext_action"]("installer", "update")
    end, {})
    vim.api.nvim_create_user_command("DppInstall", function()
        vim.fn["dpp#async_ext_action"]("installer", "install")
    end, {})
    vim.api.nvim_create_user_command("DppMakeState", function()
        vim.fn["dpp#make_state"]()
    end, {})
end

return M
