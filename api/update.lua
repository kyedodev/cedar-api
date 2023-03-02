-- pastebin get 1ivnjzgi update

local cwd      = fs.getDir(shell.getRunningProgram())
local filename = "cedar"
local file     = cwd .. "/" .. filename

local old_version



if not (cedar == nil) then
  old_version = cedar.version
  print("Cedar API found, v" .. old_version)
end


-- delete file if exists.
if fs.exists(file) then
  fs.delete(file)
end


-- installing.
shell.run("pastebin","get","tcqanvzb",filename)

os.loadAPI(file)

local new_version = cedar.version

-- comparing versions.
if old_version == nil then
  print("Cedar API installed, v" .. new_version)
elseif old_version == new_version then
  print("Cedar API is up-to-date, v" .. new_version)
else
  print("Cedar API updated, v" .. new_version)
end