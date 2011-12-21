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

def Unzip( filename, destPath ):
    if not os.path.exists( filename ):
        print "Unzip Error: File %s does not exist" % filename
    z = zipfile.ZipFile( filename )
    print "Extracting %s to %s" % ( filename, destPath )
    z.extractall( destPath )
    z.close()
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
    vimDir = os.path.expanduser( "~/.vim/" )
    bundlePath = os.path.join( vimDir, 'bundle' )
    vimPlugins = {
            'snipmate' : 11006
            }

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

    def InstallQuicksilver( self ):
        destPath = os.path.join( self.bundlePath, 'quicksilver' )
        if os.path.exists( destPath ):
        	print "Quicksilver already installed.  Skipping"
        	return
        print "Installing Quicksilver from github"
        subprocess.check_call( [ 
            'git', 
            'clone', 
            'https://github.com/Bogdanp/quicksilver.vim.git',
            destPath
            ] )

    def InstallVimPlugin( self, name, vimOrgId ):
        """ Installs a vim plug using pathogen """
        destPath = os.path.join( self.bundlePath, name )
        if os.path.exists( destPath ):
        	print "%s already installed.  Skipping" % name
        url = self.vimDownloadUrl + str( vimOrgId )
        print "Donwloading %s from %s" % ( name, url )
        filename, info = urllib.urlretrieve( url )
        origFile = info.getheader( 'content-disposition' )
        #Strip out filename bit 
        origFile = re.sub( '.*filename=', '', origFile )
        origExt = origFile[origFile.rfind( '.' ):]
        print "Saved to %s" % filename
        print "Mimetype: %s" % info.gettype()
        
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
        self.InstallQuicksilver()
        for name, vimOrgId in self.vimPlugins.iteritems():
            self.InstallVimPlugin( name, vimOrgId )
        

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

