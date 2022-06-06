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
        echo Generating html ...
        cat web/header.html >$OUTDIR/web/plugins.html
        cat web/plugins-head.html >>$OUTDIR/web/plugins.html
        cat $OUTDIR/web/plugins-content.html >>$OUTDIR/web/plugins.html
        cat web/footer.html >>$OUTDIR/web/plugins.html

        echo Uploading html ...
        rsync -a -e "$SSHOPTS" $OUTDIR/web/plugins.html waker,deadbeef@web.sourceforge.net:/home/groups/d/de/deadbeef/htdocs/ || exit 1
    ;;
esac
