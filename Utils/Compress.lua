--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Utils
]]

local LibCompress = LibStub:GetLibrary("LibCompress");

--[[--
Compress provided data.

Use `Decompress`-method to decompress compressed data.

@param[type=*] data
@return[type=string]
]]
function MyDungeonsBook:Compress(data)
    return LibCompress:Compress(self:Serialize(data));
end

--[[--
Decompress provided string.

Oposite to method `Compress`.

@param[type=string] compressedString
@return[type=*]
]]
function MyDungeonsBook:Decompress(compressedString)
    return self:Deserialize(LibCompress:Decompress(compressedString));
end
