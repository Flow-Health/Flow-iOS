MIS = mise exec -- tuist

generate:
	${MIS} install
	${MIS} generate

edit:
	${MIS} edit

clean:
	${MIS} clean

install:
	${MIS} install

graph: 
	${MIS} tuist graph

# 사용법: make module name=모듈이름
module:
	${MIS} scaffold Module --name ${name}
	${MIS} edit
