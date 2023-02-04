/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
#if PANGO_PATCH
static char font[] = "monospace 10";
#else
#if XRESOURCES_PATCH
static char *fonts[] =
#else
static const char *fonts[] =
#endif // XRESOURCES_PATCH
{
	"Hack:pixelsize=11:antialias=true:autohint=true",
	"JoyPixels:pixelsize=8:antialias=true:autohint=true"
};
#endif // PANGO_PATCH

static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#cccccc", "#282c34" },
	[SchemeSel] = { "#1c1f24", "#c678dd" },
	[SchemeSelHighlight] = { "#98be65", "#000000" },
	[SchemeNormHighlight] = { "#98be65", "#000000" },
	[SchemeOut] = { "#000000", "#51afef" },
	[SchemeMid] = { "#d7d7d7", "#1c1f24" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;
/* -h option; minimum height of a menu line */
static unsigned int lineheight = 43;
static unsigned int min_lineheight = 8;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
