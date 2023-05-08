NAME := "atahan-yorganci"
DIST := "dist"

default:
    @just --choose

clean:
    rm -rf '{{ DIST }}'

dir:
    mkdir -p '{{ DIST }}'

dev: dir
    typst watch resume.typ '{{ DIST }}/dev.pdf'

build: dir
    typst compile resume.typ '{{ DIST }}/{{ NAME }}.pdf'

upload: build
    rclone sync -P '{{ DIST }}' 'drive:/Resume'
