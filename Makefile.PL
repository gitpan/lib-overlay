#!/usr/bin/perl

use inc::Module::Install;

name('lib-overlay');
author('Autrijus Tang <autrijus@autrijus.org>');
abstract('Overlay additional code on module loading');
license('perl');
version_from('lib/lib/overlay.pm');

&WriteAll;
