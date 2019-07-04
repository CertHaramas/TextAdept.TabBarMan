-- TabBarMan.lua, LPr 7/2019

----------------------------------------------------------------------------------------------------

local TBM = {}

--[[
keys.c5 = function()
  local original_tabs = {}
  for i = 1, #_BUFFERS do
    local buffer = _BUFFERS[i]
    local filename = buffer.filename or buffer._type
    original_tabs[#original_tabs + 1] = filename
    view:goto_buffer(buffer)
  end
  io.close_all_buffers()
  io.open_file(original_tabs[#original_tabs])
  for i = 1, #original_tabs - 1 do
    io.open_file(original_tabs[i])
  end
end
--]]

TBM.moveTab = function(buf, dir)
  buf = buf or buffer

  local idx = _BUFFERS[buf]
  local lo

  if dir == ">" then
    lo = idx
  elseif dir == ">>" then
    lo = idx
  elseif dir == "<" then
    lo = idx - 1
  elseif dir == "<<" then
    lo = 1
  end

  if lo < 1 then return end

  if lo < idx then
    -- Ensure 'lo' to point after '._type' bufs

    for i = lo, #_BUFFERS do
      if _BUFFERS[i].filename then lo = i; break end
    end

    if lo == idx then return end
  end

--ui.print("idx", idx, "lo", lo)

  do
    local mod_bufs = {}

    for i = lo, #_BUFFERS do
      local buf = _BUFFERS[i]

      if buf.modify then table.insert(mod_bufs, buf) end
    end

    if #mod_bufs > 0 then
      local ans = ui.dialogs.msgbox{ title = "Unsaved buffers",
                                     text = _L["There are unsaved changes in"] .. " (... buffers ...).", -- TD: Better text
                                     icon = "gtk-dialog-warning",
                                   }
      -- TD: Process 'ans'

      do return end -- TD
    end
  end

  local bufs = {}

  for i = lo, #_BUFFERS do
    local buf = _BUFFERS[i]

    table.insert(bufs, buf)
  end

  for _, buf in ipairs(bufs) do
    buf:delete()
  end

  do
    if dir == ">" then
      if #bufs > 0 then
        bufs[1], bufs[2] = bufs[2], bufs[1]
      else
        -- No place to move
      end
    elseif dir == ">>" then
      table.insert(bufs, table.remove(bufs, 1))
    elseif dir == "<" then
      bufs[1], bufs[2] = bufs[2], bufs[1]
    elseif dir == "<<" then
      table.insert(bufs, 1, table.remove(bufs, idx - lo + 1))
    end
  end

  for _, buf in ipairs(bufs) do
    if buf.filename then io.open_file(buf.filename)
    elseif buf._type then
      -- TD
    else
      -- Should not happen
    end
  end
end

--

local _L = setmetatable({}, {__index = function(t, k) return k end}) -- Opt. - when we don't want to use [missing] locale

--

local tb_menu = textadept.menu.tab_context_menu

--

table.insert(tb_menu, { "" })

--

for _, v in ipairs{ { _L["Move tab one position left"],
                      function() TBM.moveTab(nil, "<") end,
                    },
                    { _L["Move tab one position right"],
                      function() TBM.moveTab(nil, ">") end,
                    },
                    { _L["Move tab to the lefttmost position"],
                      function() TBM.moveTab(nil, "<<") end,
                    },
                    { _L["Move tab to the rightmost position"],
                      function() TBM.moveTab(nil, ">>") end,
                    },
                  } do
  table.insert(tb_menu, v)
end

----------------------------------------------------------------------------------------------------

--return TBM
