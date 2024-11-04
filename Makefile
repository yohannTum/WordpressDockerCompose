#!make
include .env

all: clean build

build:
	mkdir .build wordpress/.build db/.build
	cp -r zip/${selected_zip_file} .build
	unzip .build/${selected_zip_file} -d .build/
	mv .build/files wordpress/.build/files
	mv .build/database.sql db/.build/database.sql

clean:
	rm -rf .build
	rm -rf db/.build
	rm -rf wordpress/.build
