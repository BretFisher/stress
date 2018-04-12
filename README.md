# Easy CPU and Memory Stressing for Docker and SwarmKit

There's lots of images/repos using `stress` or `stress-ng` but I needed something
that didn't need a custom ENTRYPOINT/CMD to work so it was easy to demo with
`docker service create`, so here we go:

> Simply running this image with various tags will get you pre-set cpu/memory stressing output.

| Image:Tag | Command |
| --------- | ------- |
| `bretfisher/stress:latest` | `stress --verbose --vm 1 --vm-bytes 256M` |
| `bretfisher/stress:256m` | `stress --verbose --vm 1 --vm-bytes 256M` |
| `bretfisher/stress:512m` | `stress --verbose --vm 1 --vm-bytes 512M` |
| `bretfisher/stress:1024m` | `stress --verbose --vm 1 --vm-bytes 1024M` |
| `bretfisher/stress:2cpu256m` | `stress --verbose --vm 2 --vm-bytes 256M` |
| `bretfisher/stress:2cpu512m` | `stress --verbose --vm 2 --vm-bytes 512M` |
| `bretfisher/stress:2cpu1024m` | `stress --verbose --vm 2 --vm-bytes 1024M` |

## Example

Notice that the task will crash so quickly that it won't "finish" deployment.

```bash
docker service create --limit-memory 200M bretfisher/stress:512m
w5656w2kynqt4xip0b321d91y
overall progress: 0 out of 1 tasks
1/1: ready     [======================================>            ]
verify: Detected task failure
Operation continuing in background.
Use `docker service ps w5656w2kynqt4xip0b321d91y` to check progress.
```
If I looked at the replica list, you'll see Swarm shutting down out-of-memory tasks and starting new ones

```bash
docker service ps w5
ID                  NAME                       IMAGE                    NODE                    DESIRED STATE       CURRENT STATE               ERROR                       PORTS
zkvjxdl7o7ej        suspicious_lamport.1       bretfisher/stress:512m   linuxkit-025000000001   Shutdown            Failed about a minute ago   "task: non-zero exit (1)"
xtvjqeh190z2         \_ suspicious_lamport.1   bretfisher/stress:512m   linuxkit-025000000001   Shutdown            Failed 2 minutes ago        "task: non-zero exit (1)"
yv7eoc5c7n2z         \_ suspicious_lamport.1   bretfisher/stress:512m   linuxkit-025000000001   Shutdown            Failed 2 minutes ago        "task: non-zero exit (1)"
xyutkbaajjc1         \_ suspicious_lamport.1   bretfisher/stress:512m   linuxkit-025000000001   Shutdown            Failed 4 minutes ago        "task: non-zero exit (1)"
```

If I looked at service logs for just one of those tasks, you'd see it start, consume memory, then crash

```bash
docker service logs w5 2>&1 | grep yv7eoc5c7n2z
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: info: [1] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: dbug: [1] using backoff sleep of 3000us
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: dbug: [1] --> hogvm worker 1 [7] forked
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: dbug: [7] allocating 536870912 bytes ...
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: dbug: [7] touching bytes in strides of 4096 bytes ...
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: FAIL: [1] (415) <-- worker 7 got signal 9
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: WARN: [1] (417) now reaping child worker processes
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: FAIL: [1] (421) kill error: No such process
suspicious_lamport.1.yv7eoc5c7n2z@linuxkit-025000000001    | stress: FAIL: [1] (451) failed run completed in 1s
```

If I was watching `docker events` I'd see it create the container, start it, have a oom event, then die

~ container create ~
~ network create ~
~ container start ~
~ container oom ~
~ container die ~
~ network disconnect ~
~ container destroy ~
