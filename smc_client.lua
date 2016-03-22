require "cord"
sh = require "stormsh"

server_ip = "fe80::212:6d02:0:4034"
server_port = 7000
bcast_port = 7777
reset_port = 8888
print("Booting CLIENT")

heard = {}

-- set up bcast recv
bcast_sock = storm.net.udpsocket(bcast_port, function(msg, from, port)
    nodeid = string.sub(from, string.len(from)-4, -1)
    print("got msg",msg,"from",from)
    for key, value in pairs(heard) do
        if key == nodeid then
            heard[key] = value + 1
            return
        end
    end
    heard[nodeid] = 1
end)

-- setup doing bcast
i = 0
storm.os.invokePeriodically(3*storm.os.SECOND, function()
    i = i + 1
    print("sending bcast", i)
    storm.net.sendto(bcast_sock, i, "ff02::1", bcast_port)
end)

-- setup doing report
report_sock = storm.net.udpsocket(server_port, function(msg, from, port)
    print('got msg?', from)
end)

report_idx = 0
storm.os.invokePeriodically(5*storm.os.SECOND, function()
    report_idx = report_idx + 1
    heard['idx'] = report_idx
    storm.net.sendto(report_sock, storm.mp.pack(heard), server_ip, server_port)
end)

sh.start()
cord.enter_loop()
