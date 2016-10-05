import os
import sys
import zipfile


def Prompt( prompt, options ):
    '''
    Prompts the user for input
    @param: prompt    Initial text for the prompt
    @param: options   A dict mapping options to functions
    @return:    Returns the same as the selected actionFunc
    '''
    entryToActionMap = []
    optionsList = []
    usedPrefixes = []
    for (text, func) in options.iteritems():
        entries = [ text ]
        if text[0] not in usedPrefixes:
            text = text[0] + '(%s)' % text[1:]
            entries.append( text[0] )
            usedPrefixes.append( text[0] )
        entryToActionMap.append( (entries, func) )
        optionsList.append( text )
    while True:
        action = raw_input( prompt + ', '.join( optionsList ) )
        for (entries, actionFunc) in entryToActionMap:
            if action in entries:
                return actionFunc()


def DoLink( orig, target ):
    '''
    Links a file in place, making a backup first
    @param: orig    The file to link from
    @param: target  The target path
    '''
    if os.path.exists( target ):
        backup = target + '.orig'
        os.rename( target, backup )
        print "Backing up original %s to %s" % ( target, backup )
    parentDir = os.path.dirname( target )
    if not os.path.exists( parentDir ):
        print "Making path %s" % parentDir
        os.makedirs( parentDir )
    print "Linking %s to %s" % ( orig, target )
    if 'symlink' in dir( os ):
        os.symlink( os.path.abspath( orig ), target )
    else:
        # Probably just python < 3.2 on windows.
        # Fall back on mklink
        subprocess.check_call( [
            'mklink', target, os.path.abspath( orig )
            ], shell=True )


def LinkFile( orig, target ):
    actualTarget = os.path.expanduser( target )
    if not os.path.exists( actualTarget ):
        DoLink( orig, actualTarget )
    else:
        if os.path.islink( actualTarget ):
            if( os.path.samefile( actualTarget, orig ) ):
                print "%s is already symlinked in place." % orig
                return
        print "%s already exists" % target

        def DoDiff():
            origFullPath = os.path.abspath( orig )
            subprocess.call(
                    [ 'diff', '-u', actualTarget, origFullPath ],
                    stdout=sys.stdout,
                    stderr=sys.stderr
                    )
            # Call LinkFile again, so we get prompted after the diff
            LinkFile( orig, target )
        Prompt( 'Action? ', {
            'replace' : lambda: DoLink( orig, actualTarget ),
            'skip' : lambda: None,
            'quit' : quit,
            'diff' : DoDiff
            } )
