-- this includes functions for file manipulation
-- it is defined in the table os

-- Date and Time
-- Two functions, date and time...
print(os.time{year=1970, month=2, day=14, hour=0}) -- 3762000

-- the date function, despite its name, is a kind of reverse 
-- of the time function: it converts a number representing
-- the date and time back to some higher level representation.
tm = os.time{year=1970, month=2, day=14, hour=0}
dt = os.date(tm)
print(dt) -- 3762000, not quite... 

print(os.date("%A, %c")) -- Friday, 08/10/18 18:36:29
--[[ Here are the possible values
%a abbreviated weekday name (e.g., Wed)
%A full weekday name (e.g., Wednesday)
%b abbreviated month name (e.g., Sep)
%B full month name (e.g., September)
%c date and time (e.g., 09/16/98 23:48:10)
%d day of the month (16) [01–31]
%H hour, using a 24-hour clock (23) [00–23]
%I hour, using a 12-hour clock (11) [01–12]
%M minute (48) [00–59]
%m month (09) [01–12]
%p either “am” or “pm” (pm)
%S second (10) [00–61]
%w weekday (3) [0–6 = Sunday–Saturday]
%x date (e.g., 09/16/98)
%X time (e.g., 23:48:10)
%Y full year (1998)
%y two-digit year (98) [00–99]
%% the character ‘%’
]]

-- you also have os.execute, os.setlocale and os.getenv, 
-- for example
