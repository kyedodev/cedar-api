-- pastebin get LGdqYmNy install_cedar
-- install the cedar api.

-- TODO: Make sure creating files within folders works.

local args = {...}

local quit = false

local api_urls = {
  {
    filename = "cedar.lua",
    url      = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/cedar.lua"
  },
  {
    filename = "update.lua",
    url      = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/update.lua"
  }
}



-- delete cedar folder in root if there is one.
if fs.exists("/cedar") then
  local msg = "Folder named 'cedar' found in root already.\nUse with '-r' to replace."

  if args[1] == nil then
    print(msg)
    return
  end

  if not (string.lower(args[1]) == "-r") then
    print(msg)
    return
  end

  fs.delete("/cedar")
  fs.makeDir("/cedar")

  print("Replaced folder.")
end





-- make function that gets file
function downloadFile(url, filename)
  if not http.checkURL(url) then
    quit = true
    return error("Invalid download url: " .. url .. "\nCheck formatting or the HTTP API configs in ComputerCraft.cfg")
  end

  local res = http.get(url)

  if res then
    local file = fs.open("/cedar/" .. filename, "w")
    file.write(res.readAll())
    file.close()
    print("Downloaded " .. filename .. ".")
  else
    quit = true
    return error("Could not download file '" .. filename .. "' from " .. url .. "\n\n" .. "Could not finish installation.\nCheck internet connection or if the HTTP API is enabled in ComputerCraft.cfg")
  end
end





-- downloading files.
for i in pairs(api_urls) do
  downloadFile(api_urls[i].url, api_urls[i].filename)
  if quit then return end -- return if ouchie.
end

print("\nRunning update program...\n")

-- update the files.
shell.run("/cedar/update.lua")