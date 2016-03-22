SMC Network Test
================

Need stormloader: `pip install stormloader`

To program the clients, plug them all into USB and run:

```
sload flashall binaries/kernel.sdb
sload programall binaries/client.elf
```

Then unplug them. Plug server mote into USB.

To program server, run:

```
sload flash binaries/kernel.sdb
sload program binaries/server.elf
```

To run the server, run:

```
sload tail | tee out.log
```

The ipython notebook can then read this log file
