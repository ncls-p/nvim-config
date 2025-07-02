-- Compatibility layer for deprecated Neovim APIs
-- This layer is loaded very early (see init.lua) so that all plugins
-- automatically benefit from the aliases provided here and no deprecation
-- warnings are displayed.

local M = {}

-- Poly-fill for table.unpack under Lua 5.1
local unpack = table.unpack or unpack

-----------------------------------------------------------------------------
-- vim.lsp compatibility
-----------------------------------------------------------------------------
if vim.lsp then
	---------------------------------------------------------------------------
	-- 1. get_active_clients ➔ get_clients
	---------------------------------------------------------------------------
	vim.lsp.get_active_clients = function(...)
		return vim.lsp.get_clients(...)
	end

	---------------------------------------------------------------------------
	-- 2. client.notify / client.request_sync (function variants)
	---------------------------------------------------------------------------
	local function patch_client(client)
		if not client or type(client) ~= "table" then
			return
		end

		-- Robust wrapper that accepts both call styles:
		--   client.notify(method, params)
		--   client.notify(client, method, params) (rare but possible)
		local function make_wrapper(method_name)
			return function(...)
				local args = { ... }
				if args[1] == client then
					table.remove(args, 1)
				end
				return client[method_name](client, unpack(args))
			end
		end

		client.notify       = make_wrapper("notify")
		client.request_sync = make_wrapper("request_sync")
	end

	-- Patch clients that are already running
	for _, c in pairs(vim.lsp.get_clients()) do
		patch_client(c)
	end

	-- Patch clients created after startup
	if vim.lsp.start_client and not vim.lsp._compat_start_client_patched then
		local orig_start_client = vim.lsp.start_client
		vim.lsp.start_client = function(config)
			local id = orig_start_client(config)
			patch_client(vim.lsp.get_client_by_id(id))
			return id
		end
		vim.lsp._compat_start_client_patched = true
	end
end

-----------------------------------------------------------------------------
-- vim.highlight ➔ vim.hl
-----------------------------------------------------------------------------
if vim.hl and vim.highlight ~= vim.hl then
	vim.highlight = vim.hl
end

-----------------------------------------------------------------------------
-- vim.validate compatibility (old table signature + short aliases)
-----------------------------------------------------------------------------
do
	local native_validate = vim.validate

	-- Mapping table for short aliases ➔ full Lua names
	local type_aliases = {
		s = "string",
		n = "number",
		b = "boolean",
		f = "function",
		t = "table",
		-- friendlier aliases
		bool = "boolean",
		num  = "number",
		func = "function",
	}

	---Checks that a value has the expected type or satisfies a predicate.
	---@param val  any
	---@param exp  string|table|function
	---@param name string
	local function assert_type(val, exp, name)
		if exp == "any" then
			return
		end

		local vtype = type(val)

		-- String ➔ single type
		if type(exp) == "string" then
			exp = type_aliases[exp] or exp
			if vtype ~= exp then
				error(string.format("'%s' doit être de type %s (reçu %s)", name, exp, vtype), 4)
			end
			return
		end

		-- Function ➔ predicate
		if type(exp) == "function" then
			local ok, res = pcall(exp, val)
			if not ok or not res then
				error(string.format("'%s' ne satisfait pas le prédicat fourni", name), 4)
			end
			return
		end

		-- Table ➔ list of types/predicates
		if type(exp) == "table" then
			for _, allowed in ipairs(exp) do
				local allowed_type = allowed
				local matches = false

				if type(allowed) == "string" then
					allowed_type = type_aliases[allowed] or allowed
					matches = (vtype == allowed_type)
				elseif type(allowed) == "function" then
					matches = allowed(val)
				end

				if matches then
					return
				end
			end
			error(string.format(
				"'%s' doit être un des types acceptés (%s) (reçu %s)",
				name,
				table.concat(vim.tbl_map(function(t)
					return type(t) == "string" and (type_aliases[t] or t) or "<func>"
				end, exp), ", "),
				vtype
			), 4)
		end

		error(string.format("Spécification de type invalide pour '%s'", name), 4)
	end

	---Compatibility: accepts the old (table) signature or delegates to the new one
	vim.validate = function(a, ...)
		-- Old signature: a single table of rules
		if type(a) == "table" and select("#", ...) == 0 then
			for name, rule in pairs(a) do
				-- Compatible with {val, exp, opt} or {val, exp, optional=true}
				local val       = rule[1]
				local exp       = rule[2] or "any"
				local opt_flag  = rule[3]
				local opt_named = false

				-- Handle named style: {val, exp, optional=true}
				if type(rule.optional) ~= "nil" then
					opt_named = rule.optional
				end

				local optional = opt_flag == true or opt_named == true

				if val == nil then
					if not optional then
						error(string.format("'%s' est obligatoire et ne peut être nil", name), 3)
					end
				else
					assert_type(val, exp, name)
				end
			end
			return true
		end

		-- New signature ➔ delegate if available
		if native_validate then
			return native_validate(a, ...)
		end

		-- Fallback: considered valid
		return true
	end
end

return M
