#!/usr/bin/env python

import os
import shutil
from utils import LinkFile

class Common(object):
    dotfiles = {}
    vimDir = os.path.expanduser( os.path.join( '~', '.vim' ) )
    vimTmp = os.path.join( vimDir, 'tmp' )

    def Install(self):
        """ Installs everything """
        self.CopyDotFiles()
        self.InstallVimColors()
        # Create vim temp folder if not already there
        if not os.path.exists( self.vimTmp ):
            print "Creating vim temp folder at %s" % self.vimTmp
            os.makedirs( self.vimTmp )
        self.InstallOthers()

    def CopyDotFiles(self):
        """ Copys dot files to appropriate locations """
        for s, d in self.dotfiles.iteritems():
            LinkFile( s, d )

    def InstallVimColors( self ):
        """ Installs vim color files """
        colorPath = os.path.join( self.vimDir, 'colors' )
        if not os.path.exists( colorPath ):
            os.makedirs( colorPath )
        srcPath = os.path.join('vim', 'colors')
        print "Copying vim color schemes into place:"
        for filename in os.listdir(srcPath):
            destPath = os.path.join(colorPath, filename)
            if not os.path.exists( destPath ):
                print "\tCopying " + filename
                shutil.copy(os.path.join(srcPath, filename), destPath)

    def InstallOthers( self ):
        '''To be overridden by child classes'''
        pass


class Windows(Common):
    vimDir = os.path.expanduser( os.path.join( '~', 'vimfiles' ) )
    dotfiles = {
            '_vimrc': os.path.join( '~', '_vimrc' )
            }


class Linux(Common):
    dotfiles = {
            '_vimrc': os.path.join( '~', '.vimrc' ),
            '_bashrc': os.path.join( '~', '.bashrc' ),
            '_zshrc': os.path.join( '~', '.zshrc' ),
            '_tmux.conf': os.path.join( '~', '.tmux.conf' ),
            '_gitconfig': os.path.join( '~', '.gitconfig' ),
            '_spacemacs': os.path.join( '~', '.spacemacs' ),
            '_proton': os.path.join( '~', '.proton' ),
            }

if __name__ == "__main__":
    if os.name == 'posix':
        obj = Linux()
    elif os.name == 'nt':
        obj = Windows()
    else:
        print "Can't determine operating system"
        quit()
    obj.Install()

