
local function set_uid(text)
	CS.UnityEngine.GameObject.Find("/BetaWatermarkCanvas(Clone)/Panel/TxtUID"):GetComponent("Text").text = tostring(text):gsub("\n", " ")
end


local function dump_json(serializer, json_writer, object)
    serializer:Serialize(json_writer, object)
end

local function dump_excel(class, get_data)

        local serializer = CS.Newtonsoft.Json.JsonSerializer()
        serializer.Converters:Add(CS.Newtonsoft.Json.Converters.StringEnumConverter())
        
        if not (CS.System.IO.Directory.Exists("./ExcelBinoutput/")) then
	        CS.System.IO.Directory.CreateDirectory("./ExcelBinoutput/");
        end

        local streamwriter = CS.System.IO.StreamWriter("./ExcelBinoutput/" .. class .. ".json")
        local jsonwriter = CS.Newtonsoft.Json.JsonTextWriter(streamwriter)
        jsonwriter.Formatting = CS.Newtonsoft.Json.Formatting.Indented

        local excel = CS[class][get_data]()

        xpcall(dump_json, function(err) 
        end, serializer, jsonwriter, excel)

        jsonwriter:Close()
        streamwriter:Close()

end

local function dump_all_excel()
    local assemblies = CS.System.AppDomain.CurrentDomain:GetAssemblies()

    local assembly = assemblies[65]
    local types = assembly:GetTypes()

    local excel_loader_classes = {}

    for i = 0, types.Length - 1 do
        local type = types[i]

        local fields = type:GetFields(CS.System.Reflection.BindingFlags.Public | CS.System.Reflection.BindingFlags.Static | CS.System.Reflection.BindingFlags.Instance | CS.System.Reflection.BindingFlags.NonPublic)

        for j = 0, fields.Length - 1 do
            local field = fields[j]
            if field.Name == "LCCHNOGEDKC" and type:GetMethod("HJGCEDGOGDH") then
                excel_loader_classes[#excel_loader_classes + 1] = type.Name
            end
        end
    end
    for _, key in ipairs(excel_loader_classes) do
        dump_excel(key, "HJGCEDGOGDH")
    end
    set_uid("complete")
end

local function on_error(error)
	set_uid(error)
	local files = io.open("./error", "w")
	files:write(error)
	files:close()
end

xpcall(dump_all_excel, on_error)