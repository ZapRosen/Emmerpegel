#!/usr/bin/perl
#Programm Emmer-pegel-vers. 0.2. pegel-2.pl
# Das Programm holt die Daten von https://www.pegelonline.nlwkn.niedersachsen.de für den 
#Pegel Bad Pyrmont. Die Daten werden in temporären Dateien pegelstand.html und pegelstand text
#zwischengespeichert. Zuerst werden die Daten als html-Datei mit allen Tags gespeichert.
#Die Datei wird vom HTML-Code getrennt. Der verbleibende Text wird als Textdatei in pegelstand.txt
#gespeichert.
#
#Danach wird der aktuelle Pegelstand als dreistellige Zahl mit Hilfe eines regulären Ausdrucks
#ausgelesen und im Terminal ausgegeben.
# 
#Erforderliche Module. Das Modul HTML::Parse ist veraltet. nach HTML::Parser verändern!
#LWP::UserAgent für die Netzbefehle
#
# Systemvoraussetzungen: installiertes Perl, Internetzugang, 
# Installation: Das Skript in ein Verzeichnis kopieren für das man Schreibrechte besitzt.
# Aufruf in einer Konsole mit dem Befehl: perl pegel-2.pl #
# Um das Programm ausführbar zu machen, musst Du auf der Konsole den Befehl eingeben
#  *  *  chmod a+rwx pegel-2.pl   *   *
# Danach kann man das Skript  mit ./pegel-2.pl starten
# Bug: Das Programm gibt eine Fehlermeldung aus. Die Ursache konnte noch nicht beseigt werden.
# Der Fehler liegt wahrscheinlich im Modul HTML::Parse
# Das Programm wurde bislang nur unter Linux getestet mit einer Perl-Installation im
# Verzeichnis /usr/bin/perl
#Programmstart: 
#
use utf8;
use strict;
use LWP::UserAgent;
use HTML::Parse;
#VariablenDeklaration
my $zeile;
my $i;
my $array1;
my @array1;
my @array2;
my $wert;
my $s; 
my $Ablesezeitpunkt; 
my $Wasserstand;

# Webseite aufrufen 
my $url='https://www.pegelonline.nlwkn.niedersachsen.de/Pegel/Binnenpegel/Name/Bad%20Pyrmont';
my $ua = LWP::UserAgent->new();
$ua->timeout(10); # timeout nach 10 Sekunden Wartezeit!!
$ua->agent('Mozilla, Firefox Quantum 64 Linux'); # Anfrage wird als Firefox ausgegeben
my $anfrage = HTTP::Request->new('GET',$url);    # Seite wird geholt
my $response = $ua->request($anfrage);				#Seite holen
#
if ($response->is_error())
	{
		print "Fehlernummer : ", $response->code() , "\n";
		print "Fehlermeldung: ", $response->message(), "\n";
	}
	else		
	{
		print "Daten geladen\n";
		# Als Datei speichern
		my $filename = 'pegelstand.html';
		my $textdatei ='pegelstand.txt';
		open DATML,">>$filename" ||die "Kann Datei $filename nicht öffnen: $! \n";
		print DATML $response->content(), "\n";
		close DATML;
		#print " $filename ist gespeichert\n";
		#
		# HTML-Tags parsen
		#
		$filename =~ s/html$/txt/;
	my	$data = parse_html($response->content())->format;
		open DATXT,">$textdatei" || die "Kann Datei $textdatei nicht öffnen: $! \n";
		print DATXT $data, "\n";
		close DATXT;
		# print "$textdatei gespeichert\n";
		#Das Zwischenspeichern der Dateien vorerst nur solange getestet wird.
		}	
#### Daten ausgeben ########

#my $WasserstandNN;
 
#Öffnen und Auslesen in Array array1 temporäre Datei pegelstand.txt oder Programm abbrechen
#
open(DATEI,"pegelstand.txt")|| die "Datei nicht gefunden";#Datei nur zum Lesen geöffnet
while($zeile=<DATEI>)
{
	push(@array1,$zeile);
}
close(DATEI);
#Datei wurde geschlossen
# nur zum Testen
#print "$array1[99], Wasserstand und Höhe über NN \n";
# 
# Die Zeile mit dem aktuellen Wert wird im Array von hinten ausgezählt und an Variable übergeben 
 $wert=$array1[-45];
 $Ablesezeitpunkt=$array1[-41];
#
#Ausgabe von $wert zum Testen
#print "\n, \n $wert, \n";
#
#wert als string an Regex-Variable $s übergeben
$s ="$wert";
#Regulärer Ausdruck: Suche eine Zahl mit drei Stellen im String! und übergib sie an die Variable $Wasserstand
$s=~ /(\d{3})/;
 $Wasserstand = $1  ;
 print "\n Wasserstand: $Wasserstand cm \n";
 print "Zeitpunkt der Ablesung:  $Ablesezeitpunkt";
 
