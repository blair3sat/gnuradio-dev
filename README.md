# blair3sat GNU Radio dev environment

This is the recommended environment for GNU Radio development.

## Getting Started
First, install Vagrant and a hypervisor (preferrably Virtualbox). Then, run:
```
vagrant up
```
This command will download the virtual machine and start it. To login, run
```
vagrant ssh
```

From there, you can `cd` into `/blair3sat`, where `install.sh` is stored. This is a shared directory, so any code written here is editable on the host in `./vm`

Then, just run `install.sh` to get your GNU Radio setup going.

## GNU Radio Companion
Theoretically, Vagrant could run a full virtualbox machine with an X GUI. However, the better alternative is probably just X forwarding.

Vagrant supports X forwarding to run X applications from inside the VM on the host X Server.

- Mac - use XQuartz
- Windows - use Xming,
- Linux - use your default X Server (or just forget Vagrant and run GNU Radio natively)

If `$DISPLAY` is set in your terminal, you should just be able to run `vagrant ssh` to begin X forwarding, and then inside the VM run `xclock` or `gnuradio-companion` to test if X is working.

## Docker image

To use the docker image, run

``` 
docker build -t blair3sat/gnuradio -f docker/Dockerfile .
``

to build it. Run:

Set your `XAUTH` variable (usually `~/.Xauthority`)
```
docker run -it --network=host --env DISPLAY=$DISPLAY --volume $XAUTH:/root/.Xauthority blair3sat/gnuradio
```

This will provide all the necessary variables to run SSH forwarding into that docker container