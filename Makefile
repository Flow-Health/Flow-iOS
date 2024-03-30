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
	${MIS} graph

# 사용법: make module name=모듈이름
module:
	${MIS} scaffold Module --name ${name}

# 사용법: make moduleAndEdit name=모듈이름
moduleAndEdit:
	${MIS} scaffold Module --name ${name}
	${MIS} edit
