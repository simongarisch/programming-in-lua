module(..., package.seeall) -- expose the require function

sm1 = require "sub_module_1"
sm2 = require "sub_module_2"

function parent_func1()
  print("Hello from parent_func_1!")
end

function parent_func2()
  print("Hello from parent_func_2!")
end