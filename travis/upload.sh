mkdir -p sshconfig

if [ ! -z $gh_rsa_key ]; then
    openssl aes-256-cbc -K $gh_rsa_key -iv $gh_rsa_iv -in .github/id_rsa.enc -out sshconfig/id_rsa -d || exit 1
elif [ ! -z $encrypted_b1899526f957_key ]; then
    openssl aes-256-cbc -K $encrypted_b1899526f957_key -iv $encrypted_b1899526f957_iv -in travis/id_rsa.enc -out sshconfig/id_rsa -d || exit 1
else
    echo "SSH key is not available, upload cancelled"
    exit 0
fi

eval "$(ssh-agent -s)"
chmod 600 sshconfig/id_rsa
ssh-add sshconfig/id_rsa || exit 1

SSHOPTS="ssh -o StrictHostKeyChecking=no -v"

if [ ! -z $GITHUB_REF ]; then
    TRAVIS_BRANCH=${GITHUB_REF#"refs/heads/"}
    echo "Ref: $GITHUB_REF"
    echo "Branch: $TRAVIS_BRANCH"
fi

OUTDIR=temp/output

case "$TRAVIS_OS_NAME" in
    linux)
        echo Uploading Linux artifacts...
#        echo i686 ...
#        rsync -a -e "$SSHOPTS" $OUTDIR/i686/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/i686 || exit 1
        echo x86_64 ...
        rsync -a -e "$SSHOPTS" $OUTDIR/x86_64/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/x86_64 || exit 1

        echo Generating html ...
        cat web/header.html >$OUTDIR/web/plugins.html
        cat web/plugins-head.html >>$OUTDIR/web/plugins.html
        cat $OUTDIR/web/plugins-content.html >>$OUTDIR/web/plugins.html
        cat web/footer.html >>$OUTDIR/web/plugins.html

        echo Uploading html ...
        rsync -a -e "$SSHOPTS" $OUTDIR/web/plugins.html waker,deadbeef@web.sourceforge.net:/home/groups/d/de/deadbeef/htdocs/ || exit 1
    ;;
    osx)
        echo Uploading Mac artifacts...
        echo x86_64 ...
        rsync -a -e "$SSHOPTS" $OUTDIR/x86_64/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/x86_64 || exit 1
    ;;
    windows)
        echo Uploading Windows artifacts...
        echo x86_64 ...
        rsync -a -e "$SSHOPTS" $OUTDIR/x86_64/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/x86_64 || exit 1
        taskkill //IM ssh-agent.exe //F
    ;;
esac
