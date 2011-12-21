#!/usr/bin/python

import os, sys
import subprocess
import shutil
import urllib

def LinkFile( orig, target, prompt=True, force=False, mkdirs=True ):
    actualTarget = os.path.expanduser( target )
    if os.path.exists( actualTarget ):
        if prompt:
            print "%s already exists" % target
            while True:
                print "Action? r(eplace), s(kip), q(uit), d(iff)"
                action = raw_input()
                if action in [ 'r', 'replace' ]:
                    break
                elif action in [ 's', 'skip' ]:
                    return
                elif action in [ 'q', 'quit' ]:
					quit()
                elif action in [ 'd', 'diff' ]:
                    subprocess.call(
                            [ 'diff', actualTarget, orig ],
                            stdout = sys.stdout,
                            stderr = sys.stderr,
                            shell = True
                            )
        elif not force:
            return
        os.unlink( actualTarget )
    parentDir = os.path.dirname( actualTarget ) 
    if not os.path.exists( parentDir ):
        if mkdirs:
            print "Making path %s" % parentDir
            os.makedirs( parentDir )
        else:
            print "Error: %s does not exist" % parentDir
            return
    print "Linking %s to %s" % ( orig, actualTarget )
    os.symlink( os.path.abspath( orig ), actualTarget )

class Common(object):
    linkOptions = {}
    dotfiles = {}
    vimDir = os.path.expanduser( "~/.vim/" )
    bundlePath = os.path.join( vimDir, 'bundle' )
    vimPlugins = {}

    vimDownloadUrl = "http://www.vim.org/scripts/download_script.php?src_id="
    pathogenVimOrgId = 16224

    def Install(self):
        """ Installs everything """
        self.CopyDotFiles()
        self.InstallVimPlugins()

    def CopyDotFiles(self):
        """ Copys dot files to appropriate locations """
        for s, d in self.dotfiles.iteritems():
            LinkFile( s, d, *self.linkOptions )

    def InstallPathogen( self ):
        pathogenFile = os.path.join( self.vimDir, 'autoload', 'pathogen.vim' )
        parentDir = os.path.dirname( pathogenFile )
        if os.path.exists( pathogenFile ):
            print "Pathogen already installed.  Skipping"
            return
        elif not os.path.exists( parentDir ):
            print "%s does not exist.  Creating" % parentDir
            os.makedirs( parentDir )
        url = self.vimDownloadUrl + str( self.pathogenVimOrgId )
        print "Donwloading pathogen from %s" % url
        urllib.urlretrieve( url, pathogenFile )
        if not os.path.exists( self.bundlePath ):
            print "%s does not exist. Creating" % self.bundlePath


    def InstallVimPlugin( self, vimOrgId ):
        """ Installs a vim plug using pathogen """
        pass

    def InstallVimPlugins(self):
        """ Installs vim plugins.  Pathogen first, followed by others """
        self.InstallPathogen()
        for vimOrgId in self.vimPlugins:
            self.InstallVimPlugin( vimOrgId )


class Windows(Common):
    vimDir = os.path.expanduser( "~/.vimfiles/" )
    dotfiles = {
            '_vimrc' : '~/_vimrc'
            }

class Linux(Common):
    dotfiles = {
            '_vimrc' : '~/.vimrc'
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

