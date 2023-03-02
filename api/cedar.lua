-- pastebin get tcqanvzb cedar
-- @author Kye Cedar

-----------------
-- VARS & VALS --
-----------------

version = "0.1.3"
PORT    = "3541"

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
  MAIN      = 0,
  TUNNEL    = 1,
  WAREHOUSE = 2
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
-- @param x           int,     x position.
-- @param y           int,     y position.
-- @param message     string,  content to print.
-- @param halign      ALIGN,   -1 = left, 0 = center, 1 = right.
-- @param valign      ALIGN,   -1 = bottom, 0 = center, 1 = top.
-- @param max_width   SIZE,    max width until wrap. -1 is auto.
-- @param max_height  SIZE,    max height until trim. -1 is auto.
-- @param wrap        bool,    if text should wrap.
function etch_ext( x, y, message, halign, valign, max_width, max_height, wrap )
  x = x or 0
  y = y or 0

  x = util.round(x)
  y = util.round(y)

  halign     = halign or ALIGN.LEFT
  valign     = valign or ALIGN.TOP
  max_width  = max_width or SIZE.AUTO
  max_height = max_height or SIZE.AUTO
  wrap       = wrap or true

  local W,H = term.getSize()

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
    if x == 1 and y == 1 then
      term.setCursorPos(2,2)
      term.write(width)
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
    term.setCursorPos(x+offset.x,y+offset.y+i-1)
    term.write(string.sub(message,width*(i-1),width*i))
  end
end



--- simple printing.
-- @param x          int,     x position.
-- @param y          int,     y position.
-- @param message    string,  content to print.
-- @param align      int,     -1 = left, 0 = center, 1 = right.
-- @param max_width  int,     max width until wrap. -1 is auto.
-- @param wrap       bool,    if text should wrap.
function etch( x, y, message, align, max_width, wrap )
  align     = align or ALIGN.LEFT
  max_width = max_width or SIZE.AUTO
  wrap      = wrap or true

  etch_ext(x,y,message,align,ALIGN.TOP,max_width,SIZE.AUTO,wrap)
end



-----------
-- MODEM --
-----------

connect["as"] = function()
end