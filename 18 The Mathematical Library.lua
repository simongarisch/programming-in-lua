-- we are now moving onto the chapters regarding the standard library

-- you have the standard trig functions (all work in radians)
trig_funcs = {math.sin, math.cos, math.tan,
              math.asin, math.acos}
for _, v in pairs(trig_funcs) do
 print(v(0))
end
print(string.rep("*", 30))
print("")

-- the math.random function generates pseudo random numbers
print(math.random())  -- 0.00125... the interval is [0,1] without args
print(math.random(5)) -- 3 interval is [0,x] with one arg x

math.randomseed(os.time()) -- we can seed with randomseed
