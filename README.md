MiniMonkey Tests
================

![Logo](doc/minimonkey_small.png)

Acceptence tests for the [minimonkey](https://github.com/Raphexion/minimonkey.git) broker.
We take advantange of the excellent [robot framework](https://robotframework.org/).

Getting Started
---------------

Clone and launch the minimonkey broker in one terminal:

```sh
git clone https://github.com/Raphexion/minimonkey.git
cd minimonkey

export god_token=myToken
rebar3 shell
application:ensure_all_started(minimonkey).
```

Run the acceptence tests in another terminal:

```sh
git clone https://github.com/Raphexion/minimonkey-tests.git
cd minimonkey-tests

pipenv install
pipenv run robot --pythonpath=libraries/ tests/
```
