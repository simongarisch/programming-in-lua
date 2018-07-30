-- 10.1 Data Description

-- https://www.lua.org/pil/20.html
print(string.format("pi = %.4f", math.pi)) -- pi = 3.1416
tag, title = "h1", "a title"
print(string.format("<%s>%s</%s>", tag, title, tag)) -- <h1>a title</h1>

-- recall ... for a variable number of arguments
function testArg(...)
  for i, v in ipairs{...} do
    print(i, v)
  end
end
testArg("here", "are", "some", "args")
--[[
1 here
2 are
3 some
4 args
]]

-- we start 10.1 by defining an auxiliary function
function fwrite(fmt, ...)
  return io.write(string.format(fmt, ...))
end
fwrite("%0.2f", math.pi) -- 3.14 as an example

-- to write the page header
function writeheader()
  io.write([[
  <html>
  <head><title>Projects using Lua</title></head>
  <body bgcolor="#FFFFFF">
  Here are brief descriptions of some projects around the
  world that use <a href="home.html">Lua</a>.
  <br>
  ]])
end

-- the first definition for entry writes each title project as a list item
function entry1(o)
  count = count + 1
  local title = o.title or "(no title)"
  fwrite('<li><a href="#%d">%s</a>\n', count, title)
end

-- and for entry2
function entry2 (o)
  count = count + 1
  fwrite('<hr>\n<h3>\n')
  local href = o.url and string.format(' href="%s"', o.url) or ''
  local title = o.title or o.org or 'org'
  fwrite('<a name="%d"%s>%s</a>\n', count, href, title)
  if o.title and o.org then
    fwrite('<br>\n<small><em>%s</em></small>', o.org)
  end
  fwrite('\n</h3>\n')
  if o.description then
    fwrite('%s<p>\n',
    string.gsub(o.description, '\n\n+', '<p>\n'))
  end
  if o.email then
    fwrite('Contact: <a href="mailto:%s">%s</a>\n',
    o.email, o.contact or o.email)
  elseif o.contact then
    fwrite('Contact: %s\n', o.contact)
  end
end

function writetail ()
  fwrite('</body></html>\n')
end

-- markov chain algorithm
-- the program generates random text, based on what words may follow a sequence of
-- n previous words in a base text
function prefix(w1, w2)
  return w1 .. " " .. w2
end

statetab = {}
function insert(index, value)
  local list = statetab[index]
  if list == nil then
    statetab[index] = {value}
  else
    list[#list+1] = value
  end
end

function allwords ()
  local line = io.read() -- current line
  local pos = 1          -- current position in the line
  return function ()     -- iterator function
    while line do -- repeat while there are lines
      local s, e = string.find(line, "%w+", pos)
      if s then -- found a word?
        pos = e + 1 -- update next position
        return string.sub(line, s, e) -- return the word
      else
        line = io.read() -- word not found; try next line
        pos = 1 -- restart from first position
      end
    end
    return nil -- no more lines: end of traversal
  end
end

local N = 2
local MAXGEN = 10000
local NOWORD = "\n"

-- build table
local w1, w2 = NOWORD, NOWORD
for w in allwords() do
  insert(prefix(w1, w2), w)
  w1 = w2; w2 = w;
end
insert(prefix(w1, w2), NOWORD)

-- generate text
w1 = NOWORD; w2 = NOWORD -- reinitialize
for i=1, MAXGEN do
  local list = statetab[prefix(w1, w2)]
  -- choose a random item from list
  local r = math.random(#list)
  local nextword = list[r]
  if nextword == NOWORD then return end
  io.write(nextword, " ")
  w1 = w2; w2 = nextword
end
