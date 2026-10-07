local URLS = {
    'https://raw.githubusercontent.com/Rem1Sec/IloveYallHoly/main/yallholy.lua',
}

local function fetch(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == 'string' and #res > 1000 then
        return res
    end
    local req = nil
    pcall(function()
        req = (typeof(getfenv) == 'function' and rawget(getfenv(), 'request'))
            or (typeof(syn) == 'table' and syn.request)
            or (typeof(http) == 'table' and http.request)
            or (typeof(fluxus) == 'table' and fluxus.request)
            or (typeof(getgenv) == 'function' and getgenv().request)
    end)
    if type(req) == 'function' then
        local ok2, resp = pcall(req, { Url = url, Method = 'GET' })
        if ok2 and type(resp) == 'table' and type(resp.Body) == 'string' and #resp.Body > 1000 then
            return resp.Body
        end
        if ok2 and type(resp) == 'string' and #resp > 1000 then
            return resp
        end
    end
    return nil
end

local src = nil
for _, url in ipairs(URLS) do
    src = fetch(url)
    if src then
        break
    end
end

if not src then
    warn('[yall holy] download failed: check executor network / HttpGet')
    return
end

local loader = loadstring or load
if type(loader) ~= 'function' then
    warn('[yall holy] no loadstring available in this executor')
    return
end

local fn, cerr = loader(src, '=yallholy')
if not fn then
    warn('[yall holy] compile error: ' .. tostring(cerr))
    return
end

local ok, err = pcall(fn)
if not ok then
    warn('[yall holy] runtime error: ' .. tostring(err))
end
