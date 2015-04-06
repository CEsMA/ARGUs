#! /bin/bash
# deb_install.sh

#Instalación PostgreSQL
	# Depenecias que posee el PostgreSQL:
		# libc6 depende de dep: libc-bin, libgcc1
			dpkg -i ./deb/libc-bin_2.11.3-4_i386;
		# libgcc1 depende de dep: gcc-4.4-base (= 4.4.5-8), libc6 (>= 2.2.4)
			dpkg -i ./deb/gcc-4.4-base_4.4.5-8_i386;
		# Dependencia circular
			# libgcc1 depende de dep: gcc-4.4-base (= 4.4.5-8), libc6 (>= 2.2.4)
			# libc6 depende de dep: libc-bin, libgcc1
			dpkg -i ./deb/libc6_2.11.3-4_i386.deb ./deb/libgcc1_4.4.5-8_i386;
		# libcomerr dep: libc6 (>= 2.3.6-6~)
		dpkg -i ./deb/libcomerr2_1.42.9-3ubuntu1.2_i386.deb;
		# libkrb dep: libc6 (>= 2.9), libcomerr2 (>= 1.34), libk5crypto3 (>= 1.8+dfsg), libkeyutils1,libkrb5support0 (= 1.8.3+dfsg-4squeeze7)
			dpkg -i ./deb/libkeyutils1_1.4-1_i386.deb;
			dpkg -i ./deb/libkrb5support0_1.8.3+dfsg-4squeeze7_i386.deb;
			# libk5crypto dep: libc6 (>= 2.4), libkeyutils1, libkrb5support0 (>= 1.7dfsg~beta2)
				dpkg -i ./deb/libk5crypto3_1.8.3+dfsg-4squeeze7_i386;
		dpkg -i ./deb/libkrb5-3_1.12+dfsg-2ubuntu5.1_i386.deb;
		# libgssapi-krb5 dep: libc6 (>= 2.7), libcomerr2 (>= 1.34), libk5crypto3 (>= 1.8+dfsg), libkeyutils1 , libkrb5-3 (= 1.8.3+dfsg-4squeeze7), libkrb5support0 (>= 1.7dfsg~beta2)
		dpkg -i ./deb/libgssapi-krb5-2_1.12+dfsg-2ubuntu5.1_i386.deb;
		# libldap dep: libc6 (>= 2.4), libgnutls26 (>= 2.7.14-0), libsasl2-2
			# libgnutls26 dep: libc6 (>= 2.3), libgcrypt11 (>= 1.4.2), libtasn1-3 (>= 1.6-0), zlib1g (>= 1:1.1.4)
				dpkg -i ./deb/libtasn1-3_2.7-1+squeeze+1_i386.deb;
				dpkg -i ./deb/zlib1g_1.2.3.4.dfsg-3_i386.deb;
				# libgcrypt11 dep: libc6 (>= 2.3), libgpg-error0 
					dpkg -i ./deb/libgpg-error0_1.6-1_i386.deb;
				dpkg -i ./deb/libgcrypt11_1.4.5-2+squeeze1_i386.deb;
			dpkg -i ./deb/libgnutls26_2.8.6-1+squeeze3_i386.deb;
			# libsasl2-2 dep: libc6 (>= 2.3), libdb4.8
				dpkg -i ./deb/libdb4.8_4.8.30-2_i386.deb;
			dpkg -i ./deb/libsasl2-2_2.1.23.dfsg1-7_i386.deb;
		dpkg -i ./deb/libldap-2.4-2_2.4.23-7.3_i386.deb;
		#  debconf dep: perl-base
			dpkg -i ./deb/perl-base_5.10.1-17squeeze6_i386.deb;
		# Depedencia recursiva depconf con depconf-english
			dpkg -i ./deb/debconf_1.5.36.1_all.deb ./deb/debconf-english_1.5.36.1_all.deb;
		dpkg -i ./deb/libssl0.9.8_0.9.8o-7ubuntu3.2.14.04.1_i386.deb;
		dpkg -i ./deb/libpam0g_1.1.1-6.1+squeeze1_i386.deb;
		dpkg -i ./deb/libpq5_9.3.6-0ubuntu0.14.04_i386.deb;
		dpkg -i ./deb/libxml2_2.9.1+dfsg1-3ubuntu4.4_i386.deb;
		dpkg -i ./deb/libxml2-dev_2.9.1+dfsg1-3ubuntu4.4_i386.deb;
		dpkg -i ./deb/locales_2.11.3-4_all.deb;
		# postgresql-client dep: libc6 (>= 2.11),libedit2 (>= 2.11-20080614-1), libpq5 (>= 8.4~0cvs20090328),libssl0.9.8 (>= 0.9.8m-1), postgresql-client-common (>= 104~), zlib1g (>= 1:1.2.3.3.dfsg)
			dpkg -i ./deb/postgresql-client-common_113+squeeze1_all.deb;
				# libedit2 dep: libbsd0 (>= 0.0), libc6 (>= 2.3.4), libncurses5 (>= 5.7+20100313)
					dpkg -i ./deb/libncurses5_5.7+20100313-5_i386.deb;
					dpkg -i ./deb/libbsd0_0.2.0-1_i386.deb;
				dpkg -i ./deb/libedit2_2.11-20080614-2_i386.deb;
		dpkg -i ./deb/postgresql-client-8.4_8.4.22-1.pgdg12.4+1_i386.deb;
		dpkg -i ./deb/tzdata_2014e-0squeeze1_all.deb;
		# ssl-cert dep: adduser, debconf (>= 0.5), openssl (>= 0.9.8g-9)
			# adduser dep: debconf, passwd (>= 1:4.0.12), perl-base (>= 5.6.0)
				# passwd dep: debianutils (>= 2.15.2), libc6 (>= 2.3), libpam-modules, libpam0g (>= 0.99.7.1), libselinux1 (>= 1.32)
					# libselinux1 dep: libc6
					dpkg -i ./deb/libselinux1_2.0.96-1_i386.deb;
					# debianultils dep: libc6 (>= 2.7), sensible-utils
						dpkg -i ./deb/sensible-utils_0.0.4_all.deb;
					dpkg -i ./deb/debianutils_3.4_i386.deb;
					# libpam-modules dep: debconf (>= 0.5), libc6 (>= 2.4), libdb4.8, libpam0g (>= 1.1.0), libselinux1 (>= 2.0.85)
					dpkg -i ./deb/libpam-modules_1.1.1-6.1+squeeze1_i386.deb;
				dpkg -i ./deb/passwd_4.1.4.2+svn3283-2+squeeze1_i386.deb;
			dpkg -i ./deb/adduser_3.112+nmu2_all.deb;	
			# openssl dep: : libc6 (>= 2.7), libssl0.9.8 (>= 0.9.8m-1), zlib1g (>= 1:1.1.4)	
			dpkg -i ./deb/openssl_0.9.8o-4squeeze14_i386.deb;
		dpkg -i ./deb/ssl-cert_1.0.28_all.deb;
		# postgresql-common dep: adduser, debconf (>= 0.5.00), postgresql-client-common (>= 113+squeeze1), ssl-cert (>= 1.0.11), lsb-base (>= 3.0-3), procps 
			# lsb-base dep: ncurses-bin, sed
				dpkg -i ./deb/sed_4.2.1-7_i386.deb;
				dpkg -i ./deb/ncurses-bin_5.7+20100313-5_i386.deb;
			dpkg -i ./deb/lsb-base_3.2-23.2squeeze1_all.deb;
			# procps dep: initscripts, libc6 (>= 2.3.4), libncurses5 (>= 5.7+20100313), libncursesw5 (>= 5.7+20100313), lsb-base (>= 3.0-10)
				# initscripts dep: libc6 (>= 2.3.4), libncurses5 (>= 5.7+20100313), libncursesw5 (>= 5.7+20100313), lsb-base (>= 3.0-10)
					# coreutils dep: libacl1 (>= 2.2.11-1), libattr1 (>= 2.4.41-1), libc6 (>= 2.6), libselinux1 (>= 1.32)
						dpkg -i ./deb/libacl1_2.2.49-4_i386.deb;
						dpkg -i ./deb/libattr1_2.4.44-2_i386.deb;
					dpkg -i ./deb/coreutils_8.5-1_i386.deb;
					#mount libblkid1 (>= 2.17.2), libc6 (>= 2.6), libselinux1 (>= 2.0.15), libsepol1 (>= 1.14), libuuid1 (>= 2.16)
						dpkg -i ./deb/libsepol1_2.0.41-1_i386.deb;
						dpkg -i ./deb/libuuid1_2.17.2-9_i386.deb;
						dpkg -i ./deb/libblkid1_2.17.2-9_i386.deb;
					dpkg -i ./deb/mount_2.17.2-9_i386.deb;
					dpkg -i ./deb/file-rc_0.8.12_all.deb;
					dpkg -i ./deb/sysvinit-utils_2.88dsf-13.1+squeeze1_i386.deb;
				dpkg -i ./deb/initscripts_2.88dsf-13.1+squeeze1_i386.deb;
				dpkg -i ./deb/libncursesw5_5.7+20100313-5_i386.deb;
		dpkg -i ./deb/postgresql-common_154_all.deb;
	dpkg -i ./deb/postgresql-8.4_8.4.22-1.pgdg12.4+1_i386;

# Instalación de Ruby 1.8.7
	# Dependecias: dep: libc0.1 (>= 2.3), libc6 (>= 2.3.5)
	# libc6.1 (>= 2.2) [ia64], libruby1.8 (= 1.8.7.302-2squeeze1),
	# 1.8 (= 1.8.7.302-2squeeze2) [not kfreebsd-i386]
		dpkg -i ./deb/libc0.1_2.11.3-4_kfreebsd-i386.deb;
		dpkg -i ./deb/libc6.1_2.11.3-4_ia64.deb;
	dpkg -i ./deb/ruby1.8_1.8.7.302-2squeeze2_i386.deb;