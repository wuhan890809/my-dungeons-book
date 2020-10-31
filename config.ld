file = {"./", exclude = {"./Locales", "./Libs"}}
project = "My Dungeons Book"
title = "My Dungeons Book Code Docs"
format = "markdown"
merge = true
no_lua_ref = true
style = "ldoc"
sort = true
all = false
custom_see_handler("^(.*)%((.*)%)$", function(page, id)
	local url = ("https://wow.gamepedia.com/%s%s"):format(page, (id and "#" .. id) or "");
	return (id and page .. "#" .. id) or page, url;
end)
new_type("db", "DB")
