require "cord"
sh = require "stormsh"

server_port = 7000
bcast_port = 7777

print("Booting Server")

heard = {}
-- set up bcast recv
bcast_sock = storm.net.udpsocket(bcast_port, function(msg, from, port)
    nodeid = string.sub(from, string.len(from)-4, -1)
    for key, value in pairs(heard) do
        if key == nodeid then
            heard[key] = value + 1
            return
        end
    end
    heard[nodeid] = 1
end)


report_i = 0
report_sock = storm.net.udpsocket(server_port, function(msg, from, port)
    nodeid = string.sub(from, string.len(from)-4, -1)
    report = storm.mp.unpack(msg)
    idx = report['idx']
    report['idx'] = nil
    for key, val in pairs(report) do
        print("remote>",nodeid, idx, key, val)
    end
end)

i = 0
storm.os.invokePeriodically(5*storm.os.SECOND, function()
    i = i + 1
    for key, val in pairs(heard) do
        print("local>", i, key, val)
    end
end)

sh.start()
cord.enter_loop()
