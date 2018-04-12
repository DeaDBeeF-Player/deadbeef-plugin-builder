echo Decrtypting id_rsa...
openssl aes-256-cbc -K $encrypted_cba67b5a8c55_key -iv $encrypted_cba67b5a8c55_iv -in travis/id_rsa.enc -out travis/id_rsa -d || exit 1
eval "$(ssh-agent -s)"
chmod 600 travis/id_rsa
ssh-add travis/id_rsa || exit 1

SSHOPTS="ssh -o StrictHostKeyChecking=no"
OUTDIR=temp/output

case "$TRAVIS_OS_NAME" in
    linux)
        echo Uploading linux artifacts...
        rsync -a -e "$SSHOPTS" $OUTDIR/i686/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/i686 || exit 1
        rsync -a -e "$SSHOPTS" $OUTDIR/x86_64/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/x86_64 || exit 1

        cat web/header.html >$OUTDIR/web/plugins.html
        cat web/plugins-head.html >>$OUTDIR/web/plugins.html
        cat $OUTDIR/web/plugins-content.html >>$OUTDIR/web/plugins.html
        cat web/footer.html >>$OUTDIR/web/plugins.html
        rsync -a -e "$SSHOPTS" $OUTDIR/web/plugins.html waker,deadbeef@web.sourceforge.net:/home/groups/d/de/deadbeef/htdocs/ || exit 1
    ;;
esac
