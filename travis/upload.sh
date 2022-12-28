mkdir -p sshconfig

if [ ! -z $gh_ed25519_key ]; then
    openssl aes-256-cbc -K $gh_ed25519_key -iv $gh_ed25519_iv -in .github/id_ed25519.enc -out sshconfig/id_ed25519 -d || exit 1
else
    echo "SSH key is not available, upload cancelled"
    exit 0
fi

eval "$(ssh-agent -s)"
chmod 600 sshconfig/id_ed25519
ssh-add sshconfig/id_ed25519 || exit 1

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
