package OMV::WhoisDomain::L10N::ja;
# $Id$

use strict;
use base 'OMV::WhoisDomain::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Add links of WHOIS service to investigate domain names of comments and received trackbacks' => 'コメントやトラックバックのドメイン名を WHOIS サービスで調査するためのリンクを追加します',

    # config.tmpl
    'WHOIS Services' => 'WHOIS サービス',
    '%s will be replaced with domain name to be ivestigated' => '%s は調査対象のドメイン名に置き換えられます',

    # OMV::WhoisIP::Callbacks
    "Investigate this domain name '[_1]' with WHOIS services below" => "このドメイン名 '[_1]' を WHOIS サービスで調べる",
);

1;