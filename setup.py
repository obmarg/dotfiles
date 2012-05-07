#!/usr/bin/python

import optparse
import os, sys
import subprocess
import shutil
import urllib
import re
from ConfigParser import ConfigParser
from utils import Prompt, LinkFile, Unzip, GetGit

mimeHandlers = {
        'application/zip' : Unzip
        }
extHandlers = {
        '.zip' : Unzip
        }

class Common(object):
    dotfiles = {}
    vimDir = os.path.expanduser( os.path.join( '~', '.vim' ) )
    vimTmp = os.path.join( vimDir, 'tmp' )

    vimDownloadUrl = "http://www.vim.org/scripts/download_script.php?src_id="
    pathogenVimOrgId = 16224

    configFile = 'dotfiles.conf'

    def __init__( self, options ):
        self.bundlePath = os.path.join( self.vimDir, 'bundle', '' )
        self.clean = options.clean
        self.LoadConfig( )

    def LoadConfig( self ):
        self.config = ConfigParser()
        self.config.read( self.configFile )
        self.vimGitPlugins = dict( self.config.items('VimGitPlugins') )
        self.vimOrgPlugins = dict( self.config.items('VimOrgPlugins') )

    def Install(self):
        """ Installs everything """
        self.CopyDotFiles()
        if self.clean:
            self.CleanVimPlugins()
        self.InstallVimPlugins()
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
            os.makedirs( self.bundlePath )

    def InstallVimPluginFromWeb( self, name, vimOrgId ):
        """ Installs a vim plug using pathogen """
        destPath = os.path.join( self.bundlePath, name )
        if os.path.exists( destPath ):
            print "%s already installed.  Skipping" % name
            return
        url = self.vimDownloadUrl + str( vimOrgId )
        print "Donwloading %s from %s" % ( name, url )
        filename, info = urllib.urlretrieve( url )
        origFile = info.getheader( 'content-disposition' )
        #Strip out filename bit 
        origFile = re.sub( '.*filename=', '', origFile )
        origExt = origFile[origFile.rfind( '.' ):]
        print "Saved to %s" % filename
        print "Mimetype: %s" % info.gettype()
        os.makedirs( destPath )
        if info.gettype() in mimeHandlers:
            # Call handler for this filetype
            mimeHandlers[ info ]( filename, destPath )
        elif origExt in extHandlers:
            extHandlers[ origExt ]( filename, destPath )
        else:
            # Just copy to destination
            shutil.move( filename, os.path.join( destPath, origFile ) ) 

    def InstallVimPlugins(self):
        """ Installs vim plugins.  Pathogen first, followed by others """
        self.InstallPathogen()
        for name, url in self.vimGitPlugins.iteritems():
            destPath = os.path.join( self.bundlePath, name )
            GetGit( name, url, destPath )
        for name, vimOrgId in self.vimOrgPlugins.iteritems():
            self.InstallVimPluginFromWeb( name, vimOrgId )

    def CleanVimPlugins( self ):
        ''' Cleans any vim plugins that setup.py has not installed '''
        print "Cleaning out old plugins"
        numCleaned = 0
        for entry in os.listdir( self.bundlePath ):
            fullPath = os.path.join( self.bundlePath, entry )
            if os.path.isdir( fullPath ):
                shouldDelete = True
                if entry in self.vimGitPlugins:
                    shouldDelete = False
                if entry in self.vimOrgPlugins:
                    shouldDelete = False
                if shouldDelete:
                    print "Removing %s" % entry
                    numCleaned += 1
                    shutil.rmtree( fullPath )
        if numCleaned == 0:
            print "No plugins removed"
        else:
            print "%i plugins removed" % numCleaned

    def InstallVimColors( self ):
        """ Installs vim color files """
        colorPath = os.path.join( self.vimDir, 'colors' )
        if not os.path.exists( colorPath ):
            os.makedirs( colorPath )
        destPath = os.path.join( colorPath, 'ir_black.vim' )
        if not os.path.exists( destPath ):
            print "Copying ir_black color scheme into place"
            shutil.copy( 'ir_black.vim', destPath )
        else:
            print "ir_black is already in place. Skipping"

    def InstallOthers( self ):
        '''To be overridden by child classes'''
        pass
        

class Windows(Common):
    vimDir = os.path.expanduser( os.path.join( '~', 'vimfiles' ) )
    dotfiles = {
            '_vimrc' : os.path.join( '~', '_vimrc' )
            }

class Linux(Common):
    dotfiles = {
            '_vimrc' : os.path.join( '~', '.vimrc' ),
            '_bashrc' : os.path.join( '~', '.bashrc' ),
            '_zshrc' : os.path.join( '~', '.zshrc' ),
            }
    ohMyZshUrl = 'git://github.com/robbyrussell/oh-my-zsh.git'

    def InstallOthers( self ):
        ''' Installs other things (in this case oh-my-zsh) '''
        getZsh = False
        try:
            getZsh = (self.config.get( 'General','OhMyZsh' ) == '1')
        except:
            pass
        if getZsh:
            destPath = os.path.expanduser( '~/.oh-my-zsh' )
            GetGit( 'Oh my zsh', self.ohMyZshUrl, destPath )

if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option( 
            '-c', '--clean', dest='clean', 
            help='clean out vim plugins', 
            action='store_true', default=False
            )
    (options, args) = parser.parse_args()

    if os.name == 'posix':
       obj = Linux( options  )
    elif os.name == 'nt':
        obj = Windows( options )
    else:
        print "Can't determine operating system"
        quit()
    obj.Install()

