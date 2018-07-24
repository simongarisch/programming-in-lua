-- here we cover how to write iterators for the generic for

local t = {"these", "are", "some", "table", "values"}
function values(t)
  local i = 0
  return function () i = i + 1; return t[i] end
end

v = values()
print(v())
print(v())
--print(v())
--print(v())
--print(v())