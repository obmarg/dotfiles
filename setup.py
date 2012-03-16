#!/usr/bin/python

import os, sys
import subprocess
import shutil
import urllib
import zipfile
import re

def LinkFile( orig, target, prompt=True, force=False, mkdirs=True ):
    actualTarget = os.path.expanduser( target )
    if os.path.exists( actualTarget ):
        if os.path.islink( actualTarget ):
            if( os.path.samefile( actualTarget, orig ) ):
            	print "%s is already symlinked in place." % orig
            	return
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
                    origFullPath = os.path.abspath( orig )
                    subprocess.call(
                            [ 'diff', '-u', actualTarget, origFullPath ],
                            stdout = sys.stdout,
                            stderr = sys.stderr
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
    if 'symlink' in dir( os ):
        os.symlink( os.path.abspath( orig ), actualTarget )
    else:
        # Probably just python < 3.2 on windows.
        # Fall back on mklink
        subprocess.check_call( [ 
            'mklink', actualTarget, os.path.abspath( orig )
            ], shell=True )

def Unzip( filename, destPath ):
    if not os.path.exists( filename ):
        print "Unzip Error: File %s does not exist" % filename
    try:
        z = zipfile.ZipFile( filename )
        print "Extracting %s to %s" % ( filename, destPath )
        z.extractall( destPath )
        z.close()
    except:
        # Fall back on running unzip
        print "Attempting unzip via external tool"
        subprocess.check_call(
                [ 'unzip', filename, '-d', destPath ]
                )
    print "Done.  Deleting %s" % filename
    os.unlink( filename )

mimeHandlers = {
        'application/zip' : Unzip
        }
extHandlers = {
        '.zip' : Unzip
        }

class Common(object):
    linkOptions = {}
    dotfiles = {}
    vimDir = os.path.expanduser( os.path.join( '~', '.vim' ) )
    vimTmp = os.path.join( vimDir, 'tmp' )

    # Vim Plugins from vim.org
    vimOrgPlugins = {
            'taglist' : 7701,
            }
    # Vim plugins from git repos
    vimGitPlugins = {
            'quicksilver' : 'git://github.com/obmarg/quicksilver.vim.git',
            'snipmate' : 'git://github.com/msanders/snipmate.vim.git',
            'pyrepl' : 'git://github.com/Bogdanp/pyrepl.vim.git',
            'git.vim' : 'git://github.com/pydave/git-vim.git',
            'mustache.vim' : 'git://github.com/juvenn/mustache.vim.git',
            'vim-coffee-script' : 'git://github.com/kchmck/vim-coffee-script.git',
            'scss-syntax' : 'git://github.com/cakebaker/scss-syntax.vim.git'
            }

    vimDownloadUrl = "http://www.vim.org/scripts/download_script.php?src_id="
    pathogenVimOrgId = 16224

    def __init__( self ):
        self.bundlePath = os.path.join( self.vimDir, 'bundle', '' )

    def Install(self):
        """ Installs everything """
        self.CopyDotFiles()
        self.InstallVimPlugins()
        self.InstallVimColors()
        # Create vim temp folder if not already there
        if not os.path.exists( self.vimTmp ):
            print "Creating vim temp folder at %s" % self.vimTmp
            os.makedirs( self.vimTmp )

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
            os.makedirs( self.bundlePath )

    def InstallVimPluginFromGit( self, name, url ):
        destPath = os.path.join( self.bundlePath, name )
        if os.path.exists( destPath ):
            print "%s already installed.  Pulling from origin" % name
            cwd = os.getcwd()
            os.chdir( destPath )
            try:
                subprocess.check_call( 'git pull', shell=True )
            finally:
                os.chdir( cwd )
        else:
            print "Installing %s from remote repo" % name
            subprocess.check_call( 
                    'git clone "%s" "%s"' % ( url, destPath ),
                    shell=True
                    )

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
            self.InstallVimPluginFromGit( name, url )
        for name, vimOrgId in self.vimOrgPlugins.iteritems():
            self.InstallVimPluginFromWeb( name, vimOrgId )

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
        

class Windows(Common):
    vimDir = os.path.expanduser( os.path.join( '~', 'vimfiles' ) )
    dotfiles = {
            '_vimrc' : os.path.join( '~', '_vimrc' )
            }

class Linux(Common):
    dotfiles = {
            '_vimrc' : os.path.join( '~', '.vimrc' ),
            '_bashrc' : os.path.join( '~', '.bashrc' ),
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

