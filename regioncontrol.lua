require 'common'

_addon.author   = 'Almavivaconte';
_addon.name     = 'RegionControl';
_addon.version  = '4.0.0';

local control_table = {}

local default_settings = {
    quiet = true
}

local ARAGONEU = {
        152,
        7,
        8,
        151,
        200,
        119,
        120
}
local BASTOK = {
        234,
        235,
        236,
        237
}
local DERFLAND = {
        147,
        197,
        109,
        148,
        110
}
local ELSHIMOLOWLANDS = {
        250,
        252,
        176,
        123
}
local ELSHIMOUPLANDS = {
        207,
        211,
        160,
        205,
        163,
        159,
        124
}
local FAUREGANDI = {
        111,
        203,
        204,
        9,
        206,
        166,
        10
}
local GUSTABERG = {
        191,
        173,
        106,
        143,
        107,
        144,
        172
}
local JEUNO = {
        243,
        244,
        245,
        246
}
local KOLSHUSHU = {
        4,
        118,
        213,
        3,
        198,
        249,
        117
}
local KUZOTZ = {
        209,
        114,
        168,
        208,
        247,
        125
}
local LITELOR = {
        153,
        202,
        154,
        251,
        122,
        121
}
local MOVALPOLOS = {
        13,
        12,
        11
}
local NORVALLEN = {
        127,
        184,
        157,
        126,
        179,
        158
}
local QUFIMISLAND = {
        127,
        184,
        157,
        126,
        179,
        158
}
local RONFAURE = {
        167,
        101,
        141,
        140,
        139,
        190,
        100,
        142
}
local SANDORIA = {
        230,
        231,
        232,
        233
}
local SARUTABARUTA = {
        146,
        116,
        170,
        145,
        192,
        194,
        169,
        115
}
local TAVNAZIA = {
        24,
        25,
        31,
        27,
        30,
        29,
        28,
        32,
        26
}
local TULIA = {
        181,
        180,
        130,
        178,
        177
}
local VALDEAUNIA = {
        6,
        161,
        162,
        165,
        5,
        112
}
local VOLLBOW = {
        113,
        201,
        212,
        174,
        128
}
local WINDURST = {
        238,
        239,
        240,
        241,
        242
}
local ZULKHEIM = {
        196,
        108,
        102,
        193,
        248,
        103
}

function sendConquestUpdateRequest() --Needed on initial load to solicit a conquest update and build the region control table; otherwise conquest updates are sent on zone and periodically as well as when the conquest map (/rmap) is accessed
    local packet = struct.pack('bbbb', 0x05A, 0, 0, 0):totable()
    AshitaCore:PacketManager():AddOutgoingPacket(0x05A, packet)
end;

function setControl()
    local playernation = AshitaCore:GetMemoryManager():GetPlayer():GetNation() + 1;
    local playerzone = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
    local zonecontrol = nil;
    if playernation == 1 then
        nationname = "San d'Oria"
    elseif playernation == 2 then
        nationname = "Bastok"
    elseif playernation == 3 then
        nationname = "Windurst"
    else
        nationname = "UNKNOWN"
    end
    if control_table[playerzone] ~= nil then
        AshitaCore:GetChatManager():QueueCommand(0, "/ac var set conquestzone true")
    else
        AshitaCore:GetChatManager():QueueCommand(0, "/ac var set conquestzone false")
    end
    if playernation == control_table[playerzone] then
        AshitaCore:GetChatManager():QueueCommand(0, "/ac var set regioncontrol true")
        if not quiet then
            AshitaCore:GetChatManager():QueueCommand(0, "/echo " .. nationname .. " controls this zone, setting Ashitacast variable regioncontrol to true.")
        end
    else
        AshitaCore:GetChatManager():QueueCommand(0, "/ac var set regioncontrol false")
        if not quiet then
            AshitaCore:GetChatManager():QueueCommand(0, "/echo " .. nationname .. " does not control this zone, setting Ashitacast variable regioncontrol to false.")
        end
    end
end;

ashita.register_event('load', function()
    -- Attempt to load the configuration..
    settings = ashita.settings.load_merged(_addon.path .. 'settings/settings.lua', default_settings);
    quiet = settings.quiet;
    print("[RegionControl] Type /rc quiet to toggle control messages on and off. If enabled, control messages are printed when you enter a zone and when a conquest update is received.")
    if quiet then
        print("[RegionControl] Current setting: Region control variable update messages will not be printed.")
    else
        print("[RegionControl] Current setting: Region control variable update messages will be printed.")
    end
    ashita.timer.once(5, sendConquestUpdateRequest)
end);

ashita.register_event('unload', function()
    -- Attempt to load the configuration..
    ashita.settings.save(_addon.path .. '/settings/settings.lua', settings);
end);



ashita.events.register('packet_in', 'packet_in_cb', function (e)
    
    if (e.id == 0x05E) then
        control_table['Ronfaure'] = struct.unpack('B', e.data, 0x1E)
        control_table['Zulkheim'] = struct.unpack('B', e.data, 0x22)
        control_table['Norvallen'] = struct.unpack('B', e.data, 0x26)
        control_table['Gustaberg'] = struct.unpack('B', e.data, 0x2A)
        control_table['Derfland'] = struct.unpack('B', e.data, 0x2E)
        control_table['Sarutabaruta'] = struct.unpack('B', e.data, 0x32)
        control_table['Kolshushu'] = struct.unpack('B', e.data, 0x36)
        control_table['Aragoneu'] = struct.unpack('B', e.data, 0x3A)
        control_table['Fauregandi'] = struct.unpack('B', e.data, 0x3E)
        control_table['Valdeaunia'] = struct.unpack('B', e.data, 0x42)
        control_table['Qufim'] = struct.unpack('B', e.data, 0x46)
        control_table['LiTelor'] = struct.unpack('B', e.data, 0x4A)
        control_table['Kuzotz'] = struct.unpack('B', e.data, 0x4E)
        control_table['Vollbow'] = struct.unpack('B', e.data, 0x52)
        control_table['ElshimoLow'] = struct.unpack('B', e.data, 0x56)
        control_table['ElshimoUp'] = struct.unpack('B', e.data, 0x5A)
        control_table['TuLia'] = struct.unpack('B', e.data, 0x5E)
        control_table['Movapolos'] = struct.unpack('B', e.data, 0x62)
        control_table['Tavnazian'] = struct.unpack('B', e.data, 0x66)
        for k,v in pairs(ARAGONEU) do
            control_table[tonumber(v)] = control_table['Aragoneu']
        end
        for k,v in pairs(BASTOK) do
            control_table[tonumber(v)] = 2
        end
        for k,v in pairs(DERFLAND) do
            control_table[tonumber(v)] = control_table['Derfland']
        end
        for k,v in pairs(ELSHIMOLOWLANDS) do
            control_table[tonumber(v)] = control_table['ElshimoLow']
        end
        for k,v in pairs(ELSHIMOUPLANDS) do
            control_table[tonumber(v)] = control_table['ElshimoUp']
        end
        for k,v in pairs(FAUREGANDI) do
            control_table[tonumber(v)] = control_table['Fauregandi']
        end
        for k,v in pairs(GUSTABERG) do
            control_table[tonumber(v)] = control_table['Gustaberg']
        end
        for k,v in pairs(KOLSHUSHU) do
            control_table[tonumber(v)] = control_table['Kolshushu']
        end
        for k,v in pairs(KUZOTZ) do
            control_table[tonumber(v)] = control_table['Kuzotz']
        end
        for k,v in pairs(LITELOR) do
            control_table[tonumber(v)] = control_table['LiTelor']
        end
        for k,v in pairs(MOVALPOLOS) do
            control_table[tonumber(v)] = control_table['Movalpolos']
        end
        for k,v in pairs(NORVALLEN) do
            control_table[tonumber(v)] = control_table['Norvallen']
        end
        for k,v in pairs(QUFIMISLAND) do
            control_table[tonumber(v)] = control_table['Qufim']
        end
        for k,v in pairs(RONFAURE) do
            control_table[tonumber(v)] = control_table['Ronfaure']
        end
        for k,v in pairs(SANDORIA) do
            control_table[tonumber(v)] = 1
        end
        for k,v in pairs(SARUTABARUTA) do
            control_table[tonumber(v)] = control_table['Sarutabaruta']
        end
        for k,v in pairs(TAVNAZIA) do
            control_table[tonumber(v)] = control_table['Tavnazian']
        end
        for k,v in pairs(TULIA) do
            control_table[tonumber(v)] = control_table['TuLia']
        end
        for k,v in pairs(VALDEAUNIA) do
            control_table[tonumber(v)] = control_table['Valdeaunia']
        end
        for k,v in pairs(VOLLBOW) do
            control_table[tonumber(v)] = control_table['Vollbow']
        end
        for k,v in pairs(WINDURST) do
            control_table[tonumber(v)] = 3
        end
        for k,v in pairs(ZULKHEIM) do
            control_table[tonumber(v)] = control_table['Zulkheim']
        end
        ashita.tasks.once(2, setControl)
    end
    
    return false;
    
end);

ashita.register_event('command', function(command, ntype)
    local args = e.command:args();
    if args[1] == '/rc' then
        if args[2] == 'quiet' then
            quiet = not quiet
            settings.quiet = quiet;
            if quiet then
                print("[RegionControl] Region control variable update messages will not be printed.")
            else
                print("[RegionControl] Region control variable update messages will be printed.")
            end
        end
    end
    return false;
end);
