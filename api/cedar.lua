-- pastebin get tcqanvzb cedar
-- @author Kye Cedar

-- note: the cedar api uses channels 35410-35419.

-----------------
-- VARS & VALS --
-----------------

version = "0.1.5"

LOGS    = {}
util    = {}
connect = {}


-- enums.
LOG_TYPE = {
  INFO  = 0,
  WARN  = 1,
  ERROR = 2
}

SIZE = {
  AUTO = -1
}

ALIGN = {
  TOP    =  1,
  LEFT   = -1,
  CENTER =  0,
  RIGHT  =  1,
  BOTTOM = -1
}

CONNECTION = {
  MAIN      = 35410,
  TUNNEL    = 35411,
  WAREHOUSE = 35412
}



-------------
-- LOGGING --
-------------

--- logs a message.
-- @param message  string,    content to log.
-- @param type     LOG_TYPE,  type of log.
function log( message, log_type )
  log_type = log_type or LOG_TYPE.INFO
  table.insert(LOGS, message)

  -- throw error is error
  if log_type == LOG_TYPE.ERROR then
    error(message)
  end
end



----------
-- UTIL --
----------

--- rounds to nearest int.
-- @param a  float,  number to round.
-- @returns {int} rounded value.
util["round"] = function(a)
  return math.floor(a+0.5)
end

--- clears screen and resets cursor position.
util["clear"] = function()
  term.clear()
  term.setCursorPos(1,1)
end



-------------
-- ETCHING --
-------------

--- printing with extra options.
-- @param options             table,      options of the etch.
-- @param options.monitor     peripheral  monitor to etch.
-- @param options.x           int,        x position.
-- @param options.y           int,        y position.
-- @param options.message     string,     content to print.
-- @param options.halign      ALIGN,      -1 = left, 0 = center, 1 = right.
-- @param options.valign      ALIGN,      -1 = bottom, 0 = center, 1 = top.
-- @param options.max_width   SIZE,       max width until wrap. -1 is auto.
-- @param options.max_height  SIZE,       max height until trim. -1 is auto.
-- @param options.wrap        bool,       if text should wrap.
function etch_ext( options )
  local monitor    = options.monitor or term
  local x          = util.round(options.x or 0)
  local y          = util.round(options.y or 0)
  local message    = option.message or ALIGN.LEFT
  local halign     = option.halign or ALIGN.TOP
  local valign     = option.valign or ALIGN.TOP
  local max_width  = option.max_width or SIZE.AUTO
  local max_height = option.max_height or SIZE.AUTO
  local wrap       = option.wrap or true

  local W,H = monitor.getSize()

  -- width of the message.
  local width  = #message
  local height = 1
  local offset = {
    x = 0,
    y = 0
  }


  -- halign, if string, then translate to ALIGN.
  -- if nil, ALIGN.LEFT by default.
  if type(halign) == "string" then
    halign = ALIGN[string.upper(halign)]
    if halign == nil then
      halign = ALIGN.LEFT
    end
  end

  -- valign, same as before, ALIGN.TOP by default.
  if type(valign) == "string" then
    valign = ALIGN[string.upper(valign)]
    if valign == nil then
      valign = ALIGN.TOP
    end
  end


  if wrap then
    -- wrap width if not size auto.
    if not (max_width == SIZE.AUTO) then
      width = math.min(#message, max_width)
    end

    -- calculate height by message length divided
    -- by allowed width.
    height = math.ceil(#message / width)

    -- trim height, if size is not AUTO,
    -- then use the smallest height.
    if not (max_height == SIZE.AUTO) then
      height = math.min(height, max_height)
    end
  end


  -- horizontal alignment.
  if halign == ALIGN.CENTER then
    offset.x = -math.ceil(width / 2)
  elseif halign == ALIGN.RIGHT then
    offset.x = -width + 1
  end


  -- vertical alignment.
  if valign == ALIGN.CENTER then
    offset.y = -math.floor(height / 2)
  elseif valign == ALIGN.BOTTOM then
    offset.y = -height + 1
  end


  -- print it.
  for i = 1, height do
    monitor.setCursorPos(x+offset.x,y+offset.y+i-1)
    monitor.write(string.sub(message,width*(i-1),width*i))
  end
end



--- simple printing.
-- @param monitor    peripheral,  monitor to print to. use term if none.
-- @param x          int,         x position.
-- @param y          int,         y position.
-- @param message    string,      content to print.
-- @param halign     ALIGN,       -1 = left, 0 = center, 1 = right.
-- @param valign     ALIGN,       -1 = bottom, 0 = center, 1 = top.
-- @param max_width  int,         max width until wrap. -1 is auto.
function etch( monitor, x, y, message, halign, valign, max_width )
  halign    = halign or ALIGN.LEFT
  valign    = valign or ALIGN.TOP
  max_width = max_width or SIZE.AUTO

  etch_ext({
    monitor = monitor,
    x = x,
    y = y,
    message = message,
    halign = halign,
    valign = valign,
    max_width = max_width,
    max_height = SIZE.AUTO,
    wrap = true
  })
end



-----------
-- MODEM --
-----------

local tModem

--- open modem connection on given channel.
-- @param modem  peripheral,  wrapped modem peripheral
link["connect"] = function(modem)
  tModem = modem
  return link
end

--- check if channel is open on modem.
-- @param channel  int,  channel to check.
-- @returns {bool} if channel is open.
link["isOpen"] = function()
end

--- open channel on connected modem.
-- @param channel  int,  channel to open.
-- @return {modem}
link["open"] = function(channel)
  if tModem == nil then
    log("Modem not connected. Use link.connect(modem).", LOG_TYPE.ERROR)
  end

  channel = channel or CONNECTION.MAIN
  channel = math.floor(channel)

  if not (channel > -1 or channel < 65535) then
    log("Not a valid channel. ( 0-65535 )", LOG_TYPE.ERROR)
  end

  if tModem.isOpen(channel) then
    log("Channel " .. channel .. " is already open.", LOG_TYPE.WARN)
  end

  tModem.open(channel)
  log("Opened channel " .. channel .. ".")

  return link
end