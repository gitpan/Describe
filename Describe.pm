# URI::Describe v0.1

# A module to describe in English information about a host-name's
# originating country and organisation.

# I HATE POD
# I HATE EVIL
# => POD IS EVIL
# => EVIL IS POD
# => BURN POD BURN POD BURN POD

# by Peter Sergeant <pete_sergeant@hotmail.com>

# Magic Package Stuff
package URI::Describe;
$VERSION = 0.1;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(%tld_hash %country_hash %sl_hash uri_describe host_lookup);

# Some declarations
use vars qw(%tld_hash %country_hash %sl_hash);
use strict;
use Socket;

# &host_lookup v0.1
# =-=-=-=-=-=- =-=-
#
# A *very* simple subroutine to look up a hostname from an I.P.
# address. The subroutine accepts a scalar containing the IP, such as
# '127.0.0.1' and returns a scalar containg the hostname, or 'Unknown'
# if the lookup failed to produce a hostname.
#
# Example:
# =======
# => $hostname = &host_lookup($ip);
#

sub host_lookup {

	my $ip = shift;
	$ip = gethostbyaddr(inet_aton($ip), AF_INET) || return "Unknown";
	return $ip;

}

	# <#PERL>

 	# <obvious> I had an IT director at a bank set me up with
 	# a machine on the internet, and when i pointed out that it
 	# seemed not to be networked, he proved it was by pointing out
 	# the icon for the IE web browser and saying "IT'S RIGHT THERE,
 	# MAN" in a condescending tone.

 	# </#PERL>

# &uri_describe v0.1
# =-=-=-=-=-=-= =-=-
#
# A routine to describe geographically a hostname. 'www.stkitt.ac.ar'
# becomes 'Argentine University', and 'www.osak.ne.jp' becomes
# 'Japanese ISP'.
#
# Example:
# =======
# => $description = &uri_describe($host);
#

sub uri_describe {

	my $uri = lc(shift);
	$uri =~ s/^\s+//;
	$uri =~ s/\s+$//;

	# If we have a .xx domain, we deal with it, and invoke
	# &_uri_describe_xx.

	if ($uri =~ m/([^\.]+)\.([a-z][a-z])$/) {
		return &_uri_describe_xx($2,$1);

	# Else, see if we have a Top-Level Domain, and, if we do,
	# return appropriate information read from %tld_hash.

	} elsif ($uri =~ m/(arpa|com|edu|int|mil|net|gov|org|nato)$/i) {

		return $tld_hash{$1};

	# Else, it's unknown to us, so it could be an IP, a local-
	# machine or aliens.

	} else {

		return;

	}
}

# This does all the complicated stuff

sub _uri_describe_xx {

	my ($tld, $sld) = @_;

	my $noun; my $adj;

	# If the countries not on the list, return 'nil points'
	if (exists $country_hash{$tld}) {
		($noun, $adj) = @{$country_hash{$tld}};
	} else {
		return;
	}

	# If the $sld (second-level-domain) has a unique entry under
	# its country (like 'ne' for Japan) then deal with it.

	if (exists ${$sl_hash{$tld}}{$sld}) {

		my $descriptor = %{$sl_hash{$tld}}->{$sld};

		if ($adj =~ m/\*/) {
			return "$descriptor in the $noun";
		} elsif ($adj =~ m/\w/) {
			return "$adj $descriptor";
		} else {
			return "$descriptor in $noun";
		}

	# Else look for standard $slds

	} elsif (exists ${$sl_hash{'all'}}{$sld}) {

		my $descriptor = %{$sl_hash{'all'}}->{$sld};;

		if ($adj =~ m/\*/) {
			return "$descriptor in the $noun";
		} elsif ($adj =~ m/\w/) {
			return "$adj $descriptor";
		} else {
			return "$descriptor in $noun";
		}


	# Else go.

	} else {

		return "$noun";
	}


}

%tld_hash = (
	'arpa',	=>	'Arpanet',
	'com'	=>	'US Commercial',
	'edu'	=>	'US Educational',
	'int'	=>	'International Organisation',
	'mil'	=>	'US Military',
	'gov'	=>	'US Government',
	'org'	=>	'Non-Profit Organisation',
	'net'	=>	'US Network',
	'nato'	=>	'NATO',
	'aero'	=>	'Air Transport Industry',
	'biz'	=>	'Business',
	'coop'	=>	'Non-profit Cooperative',
	'info'	=>	'Information Center',
	'museum'=>	'Museum',
	'name'	=>	'Named Individual',
	'pro'	=>	'Professional',
);

	# <#PERL>

	# <n3dud3> Can anyone tell me where I can get cable for a
	# Wireless network card?
	# <sheriff_p> You're kidding right?
	# <n3dud3> No?!? How else do I connect it to another computer?
	# * sheriff_p hides

	# </#PERL>

%country_hash = (

'ad'	=>	['Andorra',			'Andorran'],
'ae'	=>	['United Arab Emirates',	'Emirian'],
'af'	=>	['Afghanistan',			'Afghan'],
'ag'	=>	['Antigua or Barbuda',		'Antiguan or Barbudan'],
'ai'	=>	['Anguilla',			'Anguillan'],
'al'	=>	['Albania',			'Albanian'],
'am'	=>	['Armenia',			'Armenian'],
'an'	=>	['Netherlands Antilles',	'Netherlands Antillean'],
'ao'	=>	['Angola',			'Angolan'],
'aq'	=>	['Antarctica',			'Antartic'],
'ar'	=>	['Argentina',			'Argentine'],
'as'	=>	['American Samoa',		'American Samoan'],
'at'	=>	['Austria',			'Austrian'],
'au'	=>	['Australia',			'Australian'],
'aw'	=>	['Aruba',			'Aruban'],
'az'	=>	['Azerbaidjan',			'Azerbaijani'],
'ba'	=>	['Bosnia-Herzegovina',		'Bosnian'],
'bb'	=>	['Barbados',			'Barbadian'],
'bd'	=>	['Bangladesh',			'Bangladeshi'],
'be'	=>	['Belgium',			'Belgian'],
'bf'	=>	['Burkina Faso',		'Burkinabè'],
'bg'	=>	['Bulgaria',			'Bulgarian'],
'bh'	=>	['Bahrain',			'Bahraini'],
'bi'	=>	['Burundi',			'Burundian'],
'bj'	=>	['Benin',			'Beninese'],
'bm'	=>	['Bermuda',			'Bermudian'],
'bn'	=>	['Brunei Darussalam',		'Bruneian'],
'bo'	=>	['Bolivia',			'Bolivian'],
'br'	=>	['Brazil',			'Brazilian'],
'bs'	=>	['Bahamas',			'Bahamian'],
'bt'	=>	['Bhutan',			'Bhutanese'],
'bv'	=>	['Bouvet Island',		'Bouvet Island'],
'bw'	=>	['Botswana',			'Motswana'],
'by'	=>	['Belarus',			'Belarusian'],
'bz'	=>	['Belize',			'Belizian'],
'ca'	=>	['Canada',			'Canadian'],
'cc'	=>	['Cocos (Keeling) Islands',	'Cocos Islander'],
'cf'	=>	['Central African Republic',	'Central African Republic'],
'cg'	=>	['Congo',			'Congolese'],
'ch'	=>	['Switzerland',			'Swiss'],
'ci'	=>	['Cote D\'Ivoire',		'Ivorian'],
'ck'	=>	['Cook Islands',		'Cook Islander'],
'cl'	=>	['Chile',			'Chilean'],
'cm'	=>	['Cameroon',			'Cameroonian'],
'cn'	=>	['China',			'Chinese'],
'co'	=>	['Colombia',			'Colombian'],
'cr'	=>	['Costa Rica',			'Costa Rican'],
'cs'	=>	['Former Czechoslovakia',	'Former Czechoslovak'],
'cu'	=>	['Cuba',			'Cuban'],
'cv'	=>	['Cape Verde',			'Cape Verdean'],
'cx'	=>	['Christmas Island',		'Christmas Island'],
'cy'	=>	['Cyprus',			'Cypriot'],
'cz'	=>	['Czech Republic',		'Czech'],
'de'	=>	['Germany',			'German'],
'dj'	=>	['Djibouti',			'Djiboutian'],
'dk'	=>	['Denmark',			'Danish'],
'dm'	=>	['Dominica',			'Dominican'],
'do'	=>	['Dominican Republic',		'Dominican'],
'dz'	=>	['Algeria',			'Algerian'],
'ec'	=>	['Ecuador',			'Ecuadorean'],
'ee'	=>	['Estonia',			'Estonian'],
'eg'	=>	['Egypt',			'Egyptian'],
'eh'	=>	['Western Sahara',		''],
'es'	=>	['Spain',			'Spanish'],
'et'	=>	['Ethiopia',			'Ethiopian'],
'fi'	=>	['Finland',			'Finnish'],
'fj'	=>	['Fiji',			'Fijian'],
'fk'	=>	['Falkland Islands',		'Falkland Island'],
'fm'	=>	['Micronesia',			'Micronseian'],
'fo'	=>	['Faroe Islands',		'Faroese'],
'fr'	=>	['France',			'French'],
'fx'	=>	['France (European Territory)', 'French (European Territory)'],
'ga'	=>	['Gabon',			'Gabonese'],
'gb'	=>	['Great Britain',		'British'],
'gd'	=>	['Grenada',			'Grenadian'],
'ge'	=>	['Georgia',			'Georgian'],
'gf'	=>	['French Guyana',		'French Guyanese'],
'gh'	=>	['Ghana',			'Ghanaian'],
'gi'	=>	['Gibraltar',			'Gibraltarian'],
'gl'	=>	['Greenland',			'Greenlandic'],
'gm'	=>	['Gambia',			'Gambian'],
'gn'	=>	['Guinea',			'Guinean'],
'gp'	=>	['Guadeloupe (French)',		'Guadeloupe'],
'gq'	=>	['Equatorial Guinea',		'Equitorial Guinean'],
'gr'	=>	['Greece',			'Greek'],
'gs'	=>	['South Georgia and the South Sandwich Islands',''],
'gt'	=>	['Guatemala',			'Guatemalan'],
'gu'	=>	['Guam (USA)',			'Guamanian'],
'gw'	=>	['Guinea Bissau',		'Guinean'],
'gy'	=>	['Guyana',			'Guyanese'],
'hk'	=>	['Hong Kong',			'Chinese (Hong Kong)'],
'hm'	=>	['Heard and McDonald Islands',	'*'],
'hn'	=>	['Honduras',			'Honduran'],
'hr'	=>	['Croatia',			'Croatian'],
'ht'	=>	['Haiti',			'Haitian'],
'hu'	=>	['Hungary',			'Hungarain'],
'id'	=>	['Indonesia',			'Indonesian'],
'ie'	=>	['Ireland',			'Irish'],
'il'	=>	['Israel',			'Israeli'],
'in'	=>	['India',			'Indian'],
'io'	=>	['British Indian Ocean Territories', '*'],
'iq'	=>	['Iraq',			'Iraqi'],
'ir'	=>	['Iran',			'Iranian'],
'is'	=>	['Iceland',			'Icelandic'],
'it'	=>	['Italy',			'Italian'],
'jm'	=>	['Jamaica',			'Jamaican'],
'jo'	=>	['Jordan',			'Jordanian'],
'jp'	=>	['Japan',			'Japanese'],
'ke'	=>	['Kenya',			'Kenyan'],
'kg'	=>	['Kyrgyzstan',			'Kyrgyzstani'],
'kh'	=>	['Cambodia',			'Cambodian'],
'ki'	=>	['Kiribati',			'Kiribati'],
'km'	=>	['Comoros',			'Comoran'],
'kn'	=>	['Saint Kitts or Nevis Anguilla','Kittitian or Nevisian '],
'kp'	=>	['North Korea',			'North Korean'],
'kr'	=>	['South Korea',			'South Korean'],
'kw'	=>	['Kuwait',			'Kuwaiti'],
'ky'	=>	['Cayman Islands',		'Caymanian'],
'kz'	=>	['Kazakhstan',			'Kazakhstani'],
'la'	=>	['Laos',			'Laotian'],
'lb'	=>	['Lebanon',			'Lebanese'],
'lc'	=>	['Saint Lucia',			'Saint Lucian'],
'li'	=>	['Liechtenstein',		'Liechtenstein'],
'lk'	=>	['Sri Lanka',			'Sri Lankan'],
'lr'	=>	['Liberia',			'Libertian'],
'ls'	=>	['Lesotho',			'Sothon'],
'lt'	=>	['Lithuania',			'Lithuanian'],
'lu'	=>	['Luxembourg',			'Luxembourg'],
'lv'	=>	['Latvia',			'Latvian'],
'ly'	=>	['Libya',			'Libyan'],
'ma'	=>	['Morocco',			'Moroccan'],
'mc'	=>	['Monaco',			'Monégasque'],
'md'	=>	['Moldavia',			'Moldavian'],
'mg'	=>	['Madagascar',			'Malagasy'],
'mh'	=>	['Marshall Islands',		'Marshallese'],
'mk'	=>	['Macedonia',			'Macedonian'],
'ml'	=>	['Mali',			'Malian'],
'mm'	=>	['Burma',			'Burmese'],
'mn'	=>	['Mongolia',			'Mongolian'],
'mo'	=>	['Macau',			'Chinese'],
'mp'	=>	['Northern Mariana Islands',	'*'],
'mq'	=>	['Martinique (French)',		'Martiniquais'],
'mr'	=>	['Mauritania',			'Mauritian'],
'ms'	=>	['Montserrat',			'Montserratian'],
'mt'	=>	['Malta',			'Maltese'],
'mu'	=>	['Mauritius',			'Mauritanian'],
'mv'	=>	['Maldives',			'Maldivian'],
'mw'	=>	['Malawi',			'Malawian'],
'mx'	=>	['Mexico',			'Mexican'],
'my'	=>	['Malaysia',			'Malaysian'],
'mz'	=>	['Mozambique',			'Mozambican'],
'na'	=>	['Namibia',			'Namibian'],
'nc'	=>	['New Caledonia (French)',	'New Caledonian'],
'ne'	=>	['Niger',			'Nigerien'],
'net'	=>	['US Network',			'US Network'],
'nf'	=>	['Norfolk Island',		'Norfolk Islander'],
'ng'	=>	['Nigeria',			'Nigerian'],
'ni'	=>	['Nicaragua',			'Nicaraguan'],
'nl'	=>	['Netherlands',			'Dutch'],
'no'	=>	['Norway',			'Norwegian'],
'np'	=>	['Nepal',			'Nepalese'],
'nr'	=>	['Nauru',			'Nauruan'],
'nt'	=>	['Neutral Zone',		'Neutral Zone'],
'nu'	=>	['Niue',			'Niuean'],
'nz'	=>	['New Zealand',			'New Zealand'],
'om'	=>	['Oman',			'Omani'],
'pa'	=>	['Panama',			'Panamanian'],
'pe'	=>	['Peru',			'Peruvian'],
'pf'	=>	['Polynesia (French)',		'French Polynesian'],
'pg'	=>	['Papua New Guinea',		'Papua New Guinean'],
'ph'	=>	['Philippines',			'Filipino'],
'pk'	=>	['Pakistan',			'Pakistani'],
'pl'	=>	['Poland',			'Polish'],
'pm'	=>	['Saint Pierre and Miquelon',	'French'],
'pn'	=>	['Pitcairn Island',		'Pitcairn Islander'],
'pr'	=>	['Puerto Rico',			'Peurto Rican'],
'ps'	=>	['Palestine',			'Palestinian'],
'pt'	=>	['Portugal',			'Portuguese'],
'pw'	=>	['Palau',			'Palauan'],
'py'	=>	['Paraguay',			'Paraguayan'],
'qa'	=>	['Qatar',			'Qatari'],
're'	=>	['Reunion (French)',		'Reunionese'],
'ro'	=>	['Romania',			'Romanian'],
'ru'	=>	['Russian Federation',		'Russian'],
'rw'	=>	['Rwanda',			'Rwandan'],
'sa'	=>	['Saudi Arabia',		'Saudi Arabian'],
'sb'	=>	['Solomon Islands',		'Solomon Islander'],
'sc'	=>	['Seychelles',			'Seychellois'],
'sd'	=>	['Sudan',			'Sudanese'],
'se'	=>	['Sweden',			'Swedish'],
'sg'	=>	['Singapore',			'Singaporean'],
'sh'	=>	['Saint Helena',		'Saint Helenian'],
'si'	=>	['Slovenia',			'Slovenian'],
'sj'	=>	['Svalbard and Jan Mayen Islands','*'],
'sk'	=>	['Slovak Republic',		'Slovakian'],
'sl'	=>	['Sierra Leone',		'Sierra Leonean'],
'sm'	=>	['San Marino',			'Sammarinese'],
'sn'	=>	['Senegal',			'Senegalese'],
'so'	=>	['Somalia',			'Somali'],
'sr'	=>	['Suriname',			'Surinamese'],
'st'	=>	['Saint Tome and Principe',	'Sao Tomean'],
'su'	=>	['Former USSR',			'Former Soviet'],
'sv'	=>	['El Salvador',			'Salvardorean'],
'sy'	=>	['Syria',			'Syrian'],
'sz'	=>	['Swaziland',			'Swazi'],
'tc'	=>	['Turks and Caicos Islands',	'*'],
'td'	=>	['Chad',			'Chadian'],
'tf'	=>	['French Southern Territories',	'French Southern Territories'],
'tg'	=>	['Togo',			'Togolese'],
'th'	=>	['Thailand',			'Thai'],
'tj'	=>	['Tajikistan',			'Tajikistani '],
'tk'	=>	['Tokelau',			'Tokelauan'],
'tm'	=>	['Turkmenistan',		'Turkmen'],
'tn'	=>	['Tunisia',			'Tunisian'],
'to'	=>	['Tonga',			'Tongan'],
'tp'	=>	['East Timor',			''],
'tr'	=>	['Turkey',			'Turkish'],
'tt'	=>	['Trinidad or Tobago',		'Trinidadian or Tobagonian'],
'tv'	=>	['Tuvalu',			'Tuvaluan'],
'tw'	=>	['Taiwan',			'Taiwanese'],
'tz'	=>	['Tanzania',			'Tanzainian'],
'ua'	=>	['Ukraine',			'Ukranian'],
'ug'	=>	['Uganda',			'Ugandan'],
'uk'	=>	['United Kingdom',		'British'],
'um'	=>	['USA Minor Outlying Islands',	'*'],
'us'	=>	['United States',		'American'],
'uy'	=>	['Uruguay',			'Uruguayan'],
'uz'	=>	['Uzbekistan',			'Uzbekistani'],
'va'	=>	['Vatican City State',		'*'],
'vc'	=>	['Saint Vincent or the Grenadines','Vincentian or Grenadian'],
've'	=>	['Venezuela',			'Venezuelan'],
'vg'	=>	['British Virgin Islands',	'*'],
'vi'	=>	['US Virgin Islands',		'*'],
'vn'	=>	['Vietnam',			'Vietnamese'],
'vu'	=>	['Vanuatu',			'ni-Vanuatuan'],
'wf'	=>	['Wallis and Futuna Islands',	'*'],
'ws'	=>	['Samoa',			'Samoan'],
'ye'	=>	['Yemen',			'Yemeni'],
'yt'	=>	['Mayotte',			'Mahoran '],
'yu'	=>	['Yugoslavia',			'Yugoslav'],
'za'	=>	['South Africa',		'South African'],
'zm'	=>	['Zambia',			'Zambian'],
'zr'	=>	['Zaïre',			'Zaïrean'],
'zw'	=>	['Zimbabwe',			'Zimbabwean'],
);

%sl_hash = (

	all => {
		'org'	=>	'Non-Profit Organisation',
		'net'	=>	'Network',
		'co'	=>	'Commercial Organisation',
		'com'	=>	'Commercial Organisation',
		'ac'	=>	'Academic Organisation (University)',
		'gov'	=>	'Government Institution',
		'go'	=>	'Government Institution',
		'mil'	=>	'Military',
		'edu'	=>	'Educational Institution',
	},


	uk => {
		'mod'	=>	'Ministry of Defense',
		'plc'	=>	'Bank',
		'sch'	=>	'School',
		'nhs'	=>	'National Health Service',
		'police' =>	'Police',
	},

	jp => {
		'gr'	=>	'Group (Club)',
		'ne'	=>	'ISP',
		'ad'	=>	'Network Infrastructure',
		'or'	=>	'Organisation',
	},

);

'faux';

=head1 NAME

	URI::Describe - Return information about a host-name's
	originating country and organisation

=head1 SYNOPSIS


	use URI::Describe qw/uri_describe host_lookup/;

	$hostname = &host_lookup($ip);

	$description = &uri_describe($host);


=head1 DESCRIPTION

A module to describe geographically a hostname. 'www.stkitt.ac.ar'
becomes 'Argentine University', and 'www.osak.ne.jp' becomes
'Japanese ISP'. Also included is an IP to hostname convertor.


=head1 AUTHOR

Peter Sergeant E<lt>pete_sergeant@hotmail.comE<gt>

=head1 COPYRIGHT

Copyright 2000 Peter Sergeant.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
