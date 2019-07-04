# TextAdept.TabBarMan
Tab bar manager for TextAdept.

Due to missing & often spoken absence of possibility to rearrange tabs in tab bar I created a simple module which "somehow" provides such base functionality.
 
Limitations:
 
- It doesn't preserve state of view, i.e. current line, cursor position etc.
- It doesn't preserve bookmarks.
- It simply closes concerned buffers and reopens them [1] in a new order - this is how tabs are reordered.
- Due to [1], concerned buffers are to be unmodified (just checked, no action if they all are not saved so far).
- Just tested on my comp - here I'm having one buffer shown in just one view.
- Report bugs on git or using my mail bellow.

Just put the module so TA loads it on startup; there are no deps.
 
The module lifetime depends on when/if TA will provide the functionality by its core.
