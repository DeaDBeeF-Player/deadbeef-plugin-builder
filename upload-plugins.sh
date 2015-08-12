#!/bin/sh
OUTDIR=temp/output
rsync -avP -e ssh $OUTDIR/i686/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/i686
rsync -avP -e ssh $OUTDIR/x86_64/*.zip waker,deadbeef@frs.sourceforge.net:/home/frs/project/d/de/deadbeef/plugins/x86_64

cat web/header.html >$OUTDIR/web/plugins.html
cat web/plugins-head.html >>$OUTDIR/web/plugins.html
cat $OUTDIR/web/plugins-content.html >>$OUTDIR/web/plugins.html
cat web/footer.html >>$OUTDIR/web/plugins.html
scp $OUTDIR/web/plugins.html waker,deadbeef@web.sourceforge.net:/home/groups/d/de/deadbeef/htdocs/

