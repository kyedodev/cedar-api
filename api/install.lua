-- pastebin get LGdqYmNy install_cedar
-- install the cedar api.

-- TODO: Make sure creating files within folders works.

local args = {...}

local api_urls = {
  {
    url      = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/cedar.lua",
    filename = "cedar.lua"
  },
  {
    url      = "https://github.com/kyedodev/cedar-api/blob/main/api/update.lua",
    filename = "update.lua"
  }
}

local api_url = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/cedar.lua"
local api_url = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/cedar.lua"



-- delete cedar folder in root if there is one.
if fs.exists("/cedar") then
  local msg = "Folder named 'cedar' found in root already.\nUse with '-r' to replace."

  if args[1] == nil then
    print(msg)
    shell.exit()
  end

  if not (string.lower(args[1]) == "-r") then
    print(msg)
    shell.exit()
  end

  fs.delete("/cedar")
  fs.makeDir("/cedar")

  print("Replaced folder.")
end





-- make function that gets file
function downloadFile(url, filename)
  if not http.checkURL(url) then
    print("Invalid download url: " .. url)
    return
  end

  local res = http.get(url)

  if res then
    local file = fs.open("/cedar/" .. filename, "w")
    file.write(res.readAll())
    file.close()
    print("Downloaded " .. filename .. ".")
  else
    print("Could not download file '" .. filename .. "' from " .. url .. "\n\nCould not finish installation.\nCheck internet connection or .")
    shell.exit()
  end
end





-- downloading files.
for i in pairs(api_urls) do
  downloadFile(api_urls[i].url, api_urls[i].filename)
end


os.loadAPI("/cedar/cedar.lua")