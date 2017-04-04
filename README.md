## EPLCounter

Example of [erlangpl](https://github.com/erlanglab/erlangpl)
plugin in Elixir.

### Prerequisites

* Erlang 18.3 and up
* Elixir 1.4 and up

### Walkthrough

First you need to clone this repository and compile the plugin:
```shell
$ git clone https://github.com/erlanglab/epl_counter.git
$ cd epl_counter
$ mix compile
```

Then you need to clone and compile [`erlangpl`](https://github.com/erlanglab/erlangpl),
prebuilt packages doesn't have Elixir support yet:
```shell
$ git clone https://github.com/erlanglab/erlangpl.git
$ cd erlangpl
$ make rebar
$ make
$ ./bootstrap --with-elixir <path to your local Elixir installation>
```

> Note: path passed to `--with-elixir` option must be a path to the root
> of Elixir installation (the one with `lib` and `bin` directories)

Start the node which `erlangpl` will observe:
```shell
$ iex --name foo@127.0.0.1
```

Now you can start `erlangpl`:
```shell
$ erlangpl -n foo@127.0.0.1 -p /path/to/epl_counter/_build/dev/lib/epl_counter
```

Head over to your browser, open dev console and type in:
```js
var ws = new WebSocket("ws://localhost:8000/Elixir.EPLCounter.EPL")
ws.onmessage = function(m) { console.log(JSON.parse(m.data).data) }
```

Around every 5 seconds you should see message being logged, coming from WebSocket
connection to plugin, each time the counter should be incremented:
```js
...
{counter: 9}
{counter: 10}
{counter: 11}
...
```
