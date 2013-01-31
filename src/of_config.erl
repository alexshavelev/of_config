%%------------------------------------------------------------------------------
%% Copyright 2012 FlowForwarding.org
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%-----------------------------------------------------------------------------

%% @author Erlang Solutions Ltd. <openflow@erlang-solutions.com>
%% @author Konrad Kaplita <konrad.kaplita@erlang-solutions.com>
%% @author Krzysztof Rutka <krzysztof.rutka@erlang-solutions.com>
%% @copyright 2012 FlowForwarding.org
%% @doc Module for parsing and encoding OF-Config 1.1 XML configurations.
-module(of_config).

%% API
-export([decode/1,
         encode/1]).

-include("of_config.hrl").

%%------------------------------------------------------------------------------
%% API functions
%%------------------------------------------------------------------------------

-spec decode(xmerl_scan:xmlElement()) -> ok.
decode(XML) ->
    {ok, OFConfigSchema} = application:get_env(of_config, of_config_schema),
    {ok, Schema} = xmerl_xsd:process_schema(filename:join([code:priv_dir(of_config),
                                                           OFConfigSchema])),
    case xmerl_xsd:validate(XML, Schema) of
        {error, Error} = E ->
            E;
        {_ValidElement, _GLobalState} ->
            of_config_decoder:to_capable_switch(XML)
    end.

-spec encode(#capable_switch{}) -> of_config_encoder:simple_form().
encode(Config) ->
    of_config_encoder:to_simple_form(Config).
