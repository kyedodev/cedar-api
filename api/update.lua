-- pastebin get 1ivnjzgi update

local cwd    = fs.getDir(shell.getRunningProgram())
local folder = cwd .. "/"

local old_version

local url = "https://raw.githubusercontent.com/kyedodev/cedar-api/main/api/"

local api = {
  "cedar.lua",
  "update.lua"
}



-- fetches file from internet.
function downloadFile(filepath)
  if not http.checkURL(url .. filepath) then
    return error("Invalid download url: " .. url .. "\nCheck formatting or the HTTP API configs in ComputerCraft.cfg")
  end

  local res = http.get(url .. filepath)

  if res then
    local file = fs.open(folder .. filepath, "w")
    file.write(res.readAll())
    file.close()
    print("Downloaded " .. filepath .. ".")
  else
    return error("Could not download file '" .. filepath .. "' from " .. url .. filepath .. "\n\n" .. "Could not finish installation.\nCheck internet connection or if the HTTP API is enabled in ComputerCraft.cfg")
  end
end



-- check if api is loaded, store old version number in var.
if not (cedar == nil) then
  old_version = cedar.version
  print("Cedar API found, v" .. old_version)
end



for i in pairs(api) do
  -- deleting all files if they exist.
  local filepath = api[i]
  if fs.exists(folder .. filepath) then
    fs.delete(folder .. filepath)
  end

  -- replace file with new, improved one from download :3
  downloadFile(filepath)
end



os.loadAPI(folder .. "cedar.lua")

local new_version = cedar.version

-- comparing versions.
if old_version == nil then
  print("Cedar API installed, v" .. new_version)
elseif old_version == new_version then
  print("Cedar API is up-to-date, v" .. new_version)
else
  print("Cedar API updated, v" .. new_version)
end