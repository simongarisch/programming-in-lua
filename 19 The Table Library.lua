-- auxiliary functions to manipulate tables and arrays.

function tbl_as_string(t)
  tbl_str = ""
  for k,v in pairs(t) do
    tbl_str = tbl_str .. ", ".. tostring(v)
  end
  return tbl_str
end

-- table.insert function inserts an element in a given position
t = {1, 2, 3, 4}
table.insert(t, 3, "insert1") -- insert at position 3
print(tbl_as_string(t))       -- , 1, 2, insert1, 3, 4
table.insert(t, "insert2")    -- use the defaults
print(tbl_as_string(t))       -- , 1, 2, insert1, 3, 4, insert2
-- so looks like default is at the end of the table

-- table.remove function removes (and returns) an element
-- from a given position in the array