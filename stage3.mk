ifndef STAGE3_MK
STAGE3_MK=stage3.mk

include init.mk

stage3: install/stage3
install/stage3: install/stage2 \
	install/_stage3-gettext \
	install/_stage3-git \
	install/_stage3-groff \
	install/_stage3-system

install/_stage3-gettext:
	# -- git: dependencies
	USE="-git" ${EMERGE} --nodeps -u sys-devel/gettext
	touch $@

install/_stage3-git:
	# -- git: workaround
	${EMERGE} --oneshot -u -j '=dev-perl/Digest-HMAC-1.30.0'
	MAKEOPTS=-j1 ${EMERGE} --oneshot -u sys-apps/debianutils
	${EMERGE} --oneshot -u -j '=dev-perl/Net-SSLeay-1.360.0'
	ebuild ${EPREFIX}/usr/local/portage/dev-lang/perl/perl-5.12.4-r99.ebuild digest
	${EMERGE} -u -j dev-vcs/git
	touch $@

install/_stage3-groff:
	# -- groff: workaround
	mkdir -p ${EPREFIX}/etc/portage/env/sys-apps
	echo "export MAKEOPTS=-j1" > ${EPREFIX}/etc/portage/env/sys-apps/groff
	touch $@

install/_stage3-system:
	# -- Update system
	FEATURES=-collision-protect ${EMERGE} -u -j system
	touch $@

endif
