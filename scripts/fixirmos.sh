#!/bin/bash

sed -i \
-e 's/^\\itshape Ирмо.\+с:\\normalfont{} \(.\+\)$/\\irmos{\1}/' \
-e 's/^\\itshape Припев:\\normalfont{} \(.\+\)$/\\pripev{\1}/' \
-e 's/^Слава Отцу и Сыну и Святому Духу.$/\\slava/' \
-e 's/^И ныне и присно и во веки веков. Аминь.$/\\inyne/' \
-e 's/^\\bfseries \(.\+\)\\normalfont{}$/\\mysubtitle{\1}/' $1

