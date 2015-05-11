#!/usr/bin/sh

BUILDDIR=../../../build

cd package

if [ ! -d ${BUILDDIR} ]; then
    mkdir ${BUILDDIR}
fi


cp Makefile ${BUILDDIR}
cp *.mk ${BUILDDIR}
cp *.o ${BUILDDIR}
cp *.a ${BUILDDIR}
cp -fr scripts ${BUILDDIR}
cp -fr ../../../tools/makebin ${BUILDDIR}

