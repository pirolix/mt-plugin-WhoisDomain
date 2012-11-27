package OMV::WhoisDomain::Callbacks;
# WhoisDomain (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }



### template_source.edit_{comment|ping}
sub template_source_edit_comment {
    my ($cb, $app, $tmpl) = @_;

    #
    chomp (my $new = <<"MTMLHEREDOC");
<mt:setvarblock name="html_head" append="1">
<!-- $FULLNAME -->
<style type="text/css">
#omv_whois_domain {
        margin-top:0.5em; }
    #omv_whois_domain ul {
            margin-top:0.5em; margin-left:2em; }
</style>
</mt:setvarblock>
MTMLHEREDOC
    $$tmpl =~ s!^!$new!;
}

### template_param.edit_{comment|ping}
sub template_param_edit_comment {
    my ($cb, $app, $param, $tmpl) = @_;

    my ($domain) = ($param->{source_url} || $param->{url} || '')
        =~ m!\w+://[^/]*?([^/.]+\.[^/.]+)/.*!;
    $param->{whois_domain_name} = $domain
        or return;

    #
    my $url = $tmpl->getElementById('url') || $tmpl->getElementById('source_url')
        or return;
    my $omv_whois_domain = $tmpl->createTextNode (&instance->translate_templatized (<<'HTMLHEREDOC'));
<mt:if name="whois_domain"><!-- $FULLNAME -->
<div id="omv_whois_domain">
    <label><__trans phrase="Investigate this domain name '[_1]' with WHOIS services below" params="<mt:var whois_domain_name>"></label>
    <ul><mt:loop name="whois_domain">
        <li><a class="icon-left icon-related" href="<mt:var name="url" escape="html">" blank="omv_whois"><mt:var name="name" escape="html"></a></li></mt:loop>
    </ul>
</div></mt:if>
HTMLHEREDOC
    $url->appendChild ($omv_whois_domain);

    #
    my @whois;
    my $whois = &instance->get_config_value ('whois') || '';
    foreach (split /[\r\n]/, $whois) {
        s!^\s+|\s+$!!g;
        my ($url, $name) = ($_, $_);
        if (/\s/) {
            ($url, $name) = $url =~ /(.+?)\s+(.*)/;
        } else {
            ($name) = $url =~ m!(https?://.+?/)!;
        }
        next unless length $url;
        next unless length $name;
        $url =~ s/%s/$domain/g;
        push @whois, {
            name => $name,
            url => $url,
        };
    }
    $param->{whois_domain} = \@whois if @whois;
}

1;