# Example Reloadable Racket Website

## Prerequisites

You will need to install the following Racket packages:

    raco pkg install reloadable

The homepage of the reloadable package is
<https://github.com/tonyg/racket-reloadable>.

## Local testing

Running `src/main.rkt` starts a local server. For your convenience,

    make run

starts the server with code reloading enabled.

### Automatic code reloading

If you would like to enable the automatic code-reloading feature, set
the environment variable `SITE_RELOADABLE` to a non-empty string. (A
good place to do that is in a `run-prelude` script; see below.)

You must also delete any compiled code `.zo` files. Otherwise, the
system will not be able to correctly replace modules while running.
You can use `make clean` to delete any stray `.zo` files.

## Deployment

### Supervision

Startable using djb's [daemontools](http://cr.yp.to/daemontools.html);
symlink this directory into your services directory and start it as
usual. The `run` script starts the program, and `log/run` sets up
logging of stdout/stderr.

If the file `run-prelude` exists in the same directory as `run`, it
will be dotted in before racket is invoked. I use this to update my
`PATH` to include my locally-built racket `bin` directory, necessary
because I don't have a system-wide racket. It's also a good place to
put a `SITE_RELOADABLE` definition, if you would like that enabled for
a production deployment.

On Debian, daemontools can be installed with `apt-get install
daemontools daemontools-run`, and the services directory is
`/etc/service/`.

### Control signals

You can send signals to the running service by creating files in the
`signals/` directory. For example:

 - creating `.pull` causes the server to shell out to `git pull` and
   then exit. Daemontools will restart it.

 - creating `.restart` causes it to exit, to be restarted by
   daemontools.

 - creating `.reload` forces a reload, for when you don't have
   `SITE_RELOADABLE` defined and you want to do a one-off code reload.

In particular, a git `post-receive` hook can be used to create the
`.pull` signal in order to update the service on git push.

## Copyright and License

Copyright &copy; 2014 Tony Garnock-Jones

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
