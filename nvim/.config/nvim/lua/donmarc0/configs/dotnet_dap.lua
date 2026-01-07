local M = {}

local function join(...)
	return table.concat({ ... }, "/")
end

local function glob1(pattern)
	local r = vim.fn.glob(pattern, false, true)
	if type(r) == "table" and #r > 0 then
		return r[1]
	end
	return nil
end

local _cache = {}

function M.find_repo_root(start_dir)
	local dir = start_dir
	while dir and dir ~= "/" do
		if glob1(join(dir, "*.sln")) then
			return dir
		end
		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end
		dir = parent
	end
	return vim.fn.getcwd()
end

local function list_csproj(repo_root)
	if _cache[repo_root] then
		return _cache[repo_root]
	end
	local r = vim.fn.glob(join(repo_root, "**/*.csproj"), false, true)
	local out = {}
	for _, p in ipairs(r) do
		if not p:match("/bin/") and not p:match("/obj/") then
			table.insert(out, p)
		end
	end
	table.sort(out)
	_cache[repo_root] = out
	return out
end

function M.pick_project()
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
	if current_dir == "" then
		current_dir = vim.fn.getcwd()
	end

	local repo_root = M.find_repo_root(current_dir)
	local csprojs = list_csproj(repo_root)
	if #csprojs == 0 then
		error("[dotnet-dap] No .csproj found under repo root: " .. repo_root)
	end

	local items = { "Select .NET project to debug:" }
	for i, csproj in ipairs(csprojs) do
		local rel = csproj:gsub("^" .. vim.pesc(repo_root) .. "/", "")
		items[i + 1] = string.format("%d) %s", i, rel)
	end

	local choice = vim.fn.inputlist(items)
	if choice < 1 or choice > #csprojs then
		return nil, nil
	end

	local csproj_path = csprojs[choice]
	local project_root = vim.fn.fnamemodify(csproj_path, ":p:h")
	return project_root, csproj_path
end

local function pick_highest_net_folder(bin_debug_dir)
	local dirs = vim.fn.glob(join(bin_debug_dir, "net*"), false, true)
	if type(dirs) ~= "table" or #dirs == 0 then
		return nil
	end
	table.sort(dirs, function(a, b)
		return a > b
	end)
	return dirs[1]
end

function M.build_dll_path_for_project(project_root)
	local csproj = glob1(join(project_root, "*.csproj"))
	if not csproj then
		error("[dotnet-dap] No .csproj found in: " .. project_root)
	end

	local project_name = vim.fn.fnamemodify(csproj, ":t:r")
	local bin_debug = join(project_root, "bin/Debug")
	local net_folder = pick_highest_net_folder(bin_debug)

	local dll_guess = net_folder and join(net_folder, project_name .. ".dll") or join(bin_debug, project_name .. ".dll")

	return vim.fn.input("[nvim-dap] Path to dll: ", dll_guess, "file")
end

return M
