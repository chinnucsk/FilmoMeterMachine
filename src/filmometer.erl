%% @author Safwan Kamarrudin <shaihulud@alumni.cmu.edu>
%% @copyright 2012 Safwan Kamarrudin.

%% @doc filmometer startup code

-module(filmometer).
-author('author <author@example.com>').
-export([start/0, start_link/0, stop/0]).

ensure_started(App) ->
  case application:start(App) of
    ok ->
      ok;
    {error, {already_started, App}} ->
      ok
  end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
  ensure_started(inets),
  ensure_started(crypto),
  ensure_started(mochiweb),
  application:set_env(webmachine, webmachine_logger_module, webmachine_logger),
  ensure_started(webmachine),
  filmometer_sup:start_link().

%% @spec start() -> ok
%% @doc Start the filmometer server.
start() ->
  ensure_started(inets),
  ensure_started(crypto),
  ensure_started(mochiweb),
  application:set_env(webmachine, webmachine_logger_module, webmachine_logger),
  ensure_started(webmachine),
  application:start(filmometer).

%% @spec stop() -> ok
%% @doc Stop the filmometer server.
stop() ->
  Res = application:stop(filmometer),
  application:stop(webmachine),
  application:stop(mochiweb),
  application:stop(crypto),
  application:stop(inets),
  Res.
