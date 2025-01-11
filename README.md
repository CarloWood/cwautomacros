<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>

<h2>cwautomacros: a collection of autoconf m4 macros</h2>

<p>This project is intended for <em>developers</em> who downloaded a project with git
that uses <i>cwautomacros</i>.</p>

<p>If you have been sent here after running `autogen.sh', then
get the cwautomacros sources with <a href="https://github.com/CarloWood/cwautomacros">Anonymous git access</a>.
To install simply untar and run <code>sudo make install</code>; no compilation is needed.</p>

<p>It's all plug-and-play: the files and scripts are installed under <code>/usr/share/cwautomacros</code>
(or in <code>$CWAUTOMACROSPREFIX/share/cwautomacros</code> if you set that environment variable).
After installation, simply go back to the project that sent you here and (re-)run it's `autogen.sh' script.</p>

<h4>Environment variables</h4>
<p>Apart from <code>CWAUTOMACROSPREFIX</code>, several other environment variables might need to be
set for this tool to work. The following environment variables are used by the 'autogen.sh' script:</p>

<ul>
<li><code>AUTOMAKE</code> - the automake executable to use (default: automake).
<li><code>ACLOCAL</code> - the aclocal executable to use (default: aclocal).
<li><code>AUTOCONF</code> - the autoconf executable to use (default: autoconf).
<li><code>AUTOHEADER</code> - the autoheader executable to use (default: autoheader).
<li><code>LIBTOOL</code> - the libtool executable to use (default: libtool).
<li><code>LIBTOOLIZE</code> - the libtoolize executable to use (default: $LIBTOOL where 'libtool' is replaced with 'libtoolize').
<li><code>GETTEXT</code> - the gettext executable to use (default: gettext).
</ul>

<p>On FreeBSD one could add something like the following to <code>~/.profile</code>, for example:</p>

<pre>
export CWAUTOMACROSPREFIX=$HOME
export AUTOCONF=autoconf259
export AUTOHEADER=autoheader259
export AUTOMAKE=automake19
export ACLOCAL=aclocal19
export LIBTOOL=libtool15
</pre>

</body>
</html>
