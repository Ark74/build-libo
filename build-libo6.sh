#!/bin/bash
#Set local proxy cache
#sudo su -c "cat << APT > /etc/apt/apt.conf.d/proxy.conf
#Acquire::http::Proxy "http://192.168.0.50:3128/";
#Acquire::https::Proxy "http://192.168.0.50:3128/";
#APT"

#Increase sudo timeout 4x (60 min)
echo "Defaults        timestamp_timeout=60" | sudo tee -a /etc/sudoers.d/README
sudo apt -y install build-essential fakeroot apt-utils git

#LibreOffice
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 83FBA1751378B444
#debhelper 11
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8CF63AD3F06FC659
#Bionic
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
#Cosmic
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

sudo su -c "cat << REPO >> /etc/apt/sources.list
#deb-src http://ppa.launchpad.net/libreoffice/ppa/ubuntu xenial main 		#src-libo
#deb-src http://ppa.launchpad.net/jonathonf/debhelper/ubuntu xenial main 	#src-debhelper
#deb-src http://archive.ubuntu.com/ubuntu bionic main universe 				#src-bionic
#deb-src http://archive.ubuntu.com/ubuntu cosmic main universe 				#src-cosmic
REPO"
#   BIN    |   SOURCE    |	 REPO
# dh-autoreconf | dh-autoreconf | src-libo
sudo sed -i "/src-libo/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep dh-autoreconf
sudo apt -y install autoconf automake autopoint libtool m4 libsigsegv2
	apt source dh-autoreconf
	cd ~/dh-autoreconf-12*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../dh-autoreconf_12~ubuntu16.04.1_all.deb
sudo sed -i "/src-libo/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# debhelper | debhelper (10) | src-libo
sudo sed -i "/src-libo/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep debhelper
	apt source debhelper
	cd ~/debhelper-10.2.2*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../debhelper_10.2.2ubuntu1~ubuntu16.04.1_all.deb
sudo sed -i "/src-libo/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# dh-autoreconf | dh-autoreconf | src-debhelper
#*requirement for debhelper 11 (PPA)
sudo sed -i "/src-debhelper/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep dh-autoreconf
	apt source dh-autoreconf
	cd ~/dh-autoreconf-14*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../dh-autoreconf_14~16.04.york0_all.deb
sudo sed -i "/src-debhelper/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libarchive-cpio-perl | libarchive-cpio-perl | src-bionic
#*requirement for strip-nondeterminism
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libarchive-cpio-perl
	apt source libarchive-cpio-perl
	cd libarchive-cpio-perl-0.10/
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libarchive-cpio-perl_0.10-1_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# strip-nondeterminism | strip-nondeterminism | src-debhelper
#*requirement for debhelper (11)
sudo sed -i "/src-debhelper/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep strip-nondeterminism
	apt source strip-nondeterminism
	cd ~/strip-nondeterminism-0.037/
	#Add patch for v0.037 (Xenial backported from PPA).
	#https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=868111
	wget "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=868111;filename=0001-Add-missing-use-statements-in-handler-modules.patch;msg=10" \
	-O ../Add-missing-use-statements-in-handler-modules.patch
	patch -p1 < ../Add-missing-use-statements-in-handler-modules.patch
	dpkg-buildpackage -us -uc
sudo dpkg -i ../dh-strip-nondeterminism_0.037-1~build1~16.04.york0_all.deb \
../libfile-stripnondeterminism-perl_0.037-1~build1~16.04.york0_all.deb
sudo sed -i "/src-debhelper/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# debhelper | debhelper | src-debhelper
sudo sed -i "/src-debhelper/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep debhelper
	apt source debhelper
	cd ~/debhelper-11*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../debhelper_11ubuntu1~16.04.york0_all.deb
sudo sed -i "/src-debhelper/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# fonts-liberation2 | fonts-liberation2 | src-libo
sudo sed -i "/src-libo/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep fonts-liberation2
	apt source fonts-liberation2
	cd ~/fonts-liberation2*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../fonts-liberation2_2.00.1-5~16.04.1~lo4_all.deb
sudo sed -i "/src-libo/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libxmlsec1-dev | xmlsec1 | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libxmlsec1-dev
	apt source xmlsec1
	cd ~/xmlsec1-1.2.25
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libxmlsec1-dev_1.2.25-1build1_amd64.deb ../libxmlsec1_1.2.25-1build1_amd64.deb \
../libxmlsec1-openssl_1.2.25-1build1_amd64.deb ../libxmlsec1-gnutls_1.2.25-1build1_amd64.deb \
../libxmlsec1-nss_1.2.25-1build1_amd64.deb ../libxmlsec1-gcrypt_1.2.25-1build1_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libepubgen-dev | libepubgen | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libepubgen-dev
	apt source libepubgen-dev
	cd ~/libepubgen*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libepubgen-dev_0.1.0-2ubuntu1_amd64.deb ../libepubgen-0.1-1_0.1.0-2ubuntu1_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libqxp-dev | libqxp | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libqxp-dev
	apt source libqxp-dev
	cd ~/libqxp*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libqxp-dev_0.0.1-1_amd64.deb ../libqxp-0.0-0_0.0.1-1_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libzmf-dev | libzmf | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libzmf-dev
	apt source libzmf-dev
	cd ~/libzmf*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libzmf-dev_0.0.2-1build2_amd64.deb ../libzmf-0.0-0_0.0.2-1build2_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libstaroffice-dev | libstaroffice | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libstaroffice-dev
	apt source libstaroffice-dev
	cd ~/libstaroffice*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libstaroffice-dev_0.0.5-1_amd64.deb ../libstaroffice-0.0-0_0.0.5-1_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# firebird3.0 | firebird3.0 | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep firebird3.0
	apt source firebird3.0
	cd ~/firebird3.0*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../firebird-dev_3.0.2.32703.ds4-11ubuntu2_amd64.deb \
../libfbclient2_3.0.2.32703.ds4-11ubuntu2_amd64.deb \
../libib-util_3.0.2.32703.ds4-11ubuntu2_amd64.deb \
../firebird3.0-common_3.0.2.32703.ds4-11ubuntu2_all.deb \
../firebird3.0-common-doc_3.0.2.32703.ds4-11ubuntu2_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libmdds-dev | mdds | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libmdds-dev
	apt source libmdds-dev
	cd ~/mdds*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libmdds-dev_1.3.1-2_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libixion-dev | libixion | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libixion-dev
	apt source libixion-dev
	cd ~/libixion*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libixion-0.13-0_0.13.0-2_amd64.deb ../libixion-dev_0.13.0-2_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# liborcus-dev | liborcus | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep liborcus-dev
	apt source liborcus-dev
	cd ~/liborcus-*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../liborcus-dev_0.13.4-2_amd64.deb \
../liborcus-0.13-0_0.13.4-2_amd64.deb \
../liborcus-spreadsheet-model-0.13-0_0.13.4-2_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libnumbertext | libnumbertext | src-cosmic
sudo sed -i "/src-cosmic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libnumbertext
	apt source libnumbertext
	cd ~/libnumbertext*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libnumbertext-dev_1.0-2_amd64.deb \
../libnumbertext-1.0-0_1.0-2_amd64.deb \
../libnumbertext-data_1.0-2_all.deb
sudo sed -i "/src-cosmic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

#Preparation for LibreOffice
sudo apt -y build-dep libreoffice
#Missing dependancies
sudo apt -y install libcmis-dev libeot-dev librevenge-dev libvlc-dev \
libodfgen-dev libwpd-dev libwpg-dev libwps-dev libvisio-dev libcdr-dev \
libmspub-dev libmwaw-dev libetonyek-dev libfreehand-dev libe-book-dev \
libabw-dev libpagemaker-dev libglm-dev coinor-libcoinmp-dev \
coinor-libcoinutils-dev libsac-java libxml-java libflute-java \
libpentaho-reporting-flow-engine-java libserializer-java libbz2-dev
#New requirements found
sudo apt -y install dh-apparmor fonts-crosextra-carlito fonts-dejavu ghostscript \
hunspell-en-us imagemagick libavahi-client-dev libboost-filesystem-dev \
libboost-locale-dev libdconf-dev libebook1.2-dev \
pstoedit python3-lxml rdfind symlinks

#here was debhelper 11

#gpgme_ss{
# libgpg-error-dev | libgpg-error | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libgpg-error-dev
	apt source libgpg-error-dev
	cd ~/libgpg-error-*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libgpg-error-dev_1.27-6_amd64.deb \
../libgpg-error0_1.27-6_amd64.deb \
../libgpg-error-mingw-w64-dev_1.27-6_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libgcrypt20-dev | libgcrypt20 | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libgcrypt20-dev
	apt source libgcrypt20
	cd ~/libgcrypt20*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libgcrypt20_1.8.1-4ubuntu1_amd64.deb \
../libgcrypt11-dev_1.5.4-3+really1.8.1-4ubuntu1_amd64.deb \
../libgcrypt20-dev_1.8.1-4ubuntu1_amd64.deb \
../libgcrypt-mingw-w64-dev_1.8.1-4ubuntu1_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libksba-dev | libksba | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libksba-dev
	apt source libksba
	cd ~/libksba*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libksba-dev_1.3.5-2_amd64.deb \
../libksba8_1.3.5-2_amd64.deb \
../libksba-mingw-w64-dev_1.3.5-2_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libassuan-dev | libassuan | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libassuan-dev
	apt source libassuan
	cd ~/libassuan*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libassuan0_2.5.1-2_amd64.deb \
../libassuan-dev_2.5.1-2_amd64.deb \
../libassuan-mingw-w64-dev_2.5.1-2_all.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME
	
#finally u_u!
# libgpgme-dev | gpgme1.0 | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep libgpgme-dev
##Option 1 - Source
	apt source gpgme1.0
	cd ~/gpgme1.0*
	./configure
	make
sudo make install
sudo ln -s /usr/local/include/gpgme.h /usr/include/
sudo ln -s /usr/local/include/gpgme /usr/include/
sudo ln -s /usr/local/include/gpgme++ /usr/include/
sudo ln -s /usr/local/include/QGpgME /usr/include/
sudo ln -s /usr/local/lib/libgpgme.so /usr/lib/x86_64-linux-gnu/
sudo ln -s /usr/local/lib/libgpgme.so.11 /usr/lib/x86_64-linux-gnu/
sudo ln -s /usr/local/lib/libgpgmepp.so /usr/lib/x86_64-linux-gnu/
sudo ln -s /usr/local/lib/libgpgmepp.so.6 /usr/lib/x86_64-linux-gnu/
sudo ln -s /usr/local/lib/libqgpgme.so /usr/lib/x86_64-linux-gnu/
sudo ln -s /usr/local/lib/cmake/* /usr/lib/x86_64-linux-gnu/cmake/
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

#if [ GPGME = 1 ]; then
##Option 2 - Deb build*
#	apt source gpgme1.0
#	cd ~/gpgme1.0*
#	sed -i "s|--infodir=/usr/share/info|--infodir=/usr/share/info \\\|" debian/rules
#	sed -i '/--infodir=/a \ \ \ \ \ \ \ \ \ \ \ \ --disable-gpg-test' debian/rules
#	sed -i "207i  private:\\
#\    /* This apparently does not work under ASAN currently. TODO fix and reeanble */" lang/qt/tests/t-encrypt.cpp
	#dpkg-buildpackage -us -uc
#	dpkg-buildpackage -rfakeroot -b
#Note: gnupg2 requirement not meet, skip.
#fi
#}
#end-of-gpgme(ss)

#Yet another requirement (found deep during build) :-/ 
# cppunit | cppunit | src-bionic
sudo sed -i "/src-bionic/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
sudo apt -y build-dep cppunit
	apt source cppunit
	cd ~/cppunit*
	dpkg-buildpackage -us -uc
sudo dpkg -i ../libcppunit-dev_1.14.0-3_amd64.deb ../libcppunit-1.14-0_1.14.0-3_amd64.deb
sudo sed -i "/src-bionic/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME

# libreoffice | libreoffice | src-libo
sudo sed -i "/src-libo/ s|#deb-src|deb-src|" /etc/apt/sources.list
sudo apt update
	apt source libreoffice
	cd ~/libreoffice-6*
	dpkg-buildpackage -us -uc
sudo sed -i "/src-libo/ s|deb-src|#deb-src|" /etc/apt/sources.list
sudo apt update
	cd $HOME
