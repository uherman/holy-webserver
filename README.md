# HolyC WebServer

This is just a fun project where i write a WebServer using [HolyC](https://holyc-lang.com/).


## Build & Run

First install the [holyc-lang compiler](https://github.com/Jamesbarford/holyc-lang)

```sh
git clone https://github.com/Jamesbarford/holyc-lang
cd holyc-lang
make
sudo make install
```

Compile the webserver
```sh
hcc main.HC -o server
```

Run the webserver
```sh
./server
```

Now you can go to `localhost:8080` to see the server running.

## Next Steps

Here are some of the next steps for the project:

- Find a way to host this on arm64 - Thinking QEMU, just have to figure out how to use it in k3s.
- Implement a HTML module to render HTML to the browser.
- Add abstractions for the routing and for responses.

<br/>
<br/>

> **Psalms 91:3-4**\
> *Surely he shall deliver thee from the snare of the fowler,\
> And from the noisome pestilence.\
> He shall cover thee with his feathers, and under his wings shalt thou trust:\
> His truth shall be thy shield and buckler.*
