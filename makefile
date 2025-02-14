CC=g++

CWARN=-Wno-unused-parameter
CERROR=

COMPILEFLAGS=-O3 -pipe -Wall -Wextra -pedantic -std=c++17 $(CWARN) $(CERROR)
LINKERFLAG=-O3 -lm -flto -static -static-libgcc
#COMPILEFLAGS=-O0 -ggdb -pipe -Wall -Wextra -pedantic -std=c++17 $(CWARN) $(CERROR)
#LINKERFLAG=-O0 -ggdb

.PHONY = myparser clean 

BISON_BIN=bison
UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	BOOST_ROOT := $(shell brew --prefix boost)
	
	CXXFLAGS := -I$(BOOST_ROOT)/include
	LDFLAGS := -L$(BOOST_ROOT)/lib
	
	LINKERFLAG=-O3 -lm

	COMPILE_MAC_FLAGS := ${LDFLAGS} ${CXXFLAGS}
	COMPILEFLAGS += ${COMPILE_MAC_FLAGS}

	BISON_BIN="$(shell brew --prefix bison)/bin/bison"
else 
	LINKERFLAG=-O3 -lm -flto -static -static-libgcc
endif



MutroseMissionDecomposer: src/hddl/hddl-token.o src/hddl/hddl.o src/main.o src/utils/sortexpansion.o src/utils/parsetree.o src/utils/config_utils.o src/utils/util.o src/utils/domain.o src/utils/predicate_utils.o src/utils/output.o src/utils/parametersplitting.o src/utils/cwa.o src/utils/typeof.o src/utils/orderingDecomposition.o src/utils/plan.o src/utils/verify.o src/utils/properties.o src/utils/condition.o src/queryparser/queryparser-token.o src/queryparser/queryparser.o src/conditionparser/conditionparser-token.o src/conditionparser/conditionparser.o src/utils/gm_utils.o src/contextmanager/contextmanager.o src/gm/gm.o src/tdg/tdg.o src/utils/query_utils.o src/utils/annotmanagerutils.o src/annotmanager/annotmanager.o src/rannot/rannot-token.o src/rannot/rannot.o src/utils/atmanagerutils.o src/atmanager/at_manager.o src/config/config.o src/knowledgemanager/knowledgemanager.o src/knowledgemanager/fileknowledgemanager.o src/knowledgemanager/knowledgemanagerfactory.o src/knowledgebase/knowledgebase.o src/utils/mission_decomposer_utils.o src/missiondecomposer/missiondecomposer.o src/constraintmanager/constraintmanager.o src/utils/validmissiongeneratorutils.o src/validmissiongenerator/validmissiongenerator.o src/utils/outputgeneratorutils.o src/outputgenerator/outputgenerator.o src/outputgenerator/xmloutputgenerator.o src/outputgenerator/jsonoutputgenerator.o src/outputgenerator/fileoutputgeneratorfactory.o src/configchecker/configchecker.o src/ihtngenerator/ihtngenerator.o src/utils/ihtn_generator_utils.o
	${CC} ${LINKERFLAG} ${COMPILE_MAC_FLAGS} $^ -o MutroseMissionDecomposer -lboost_filesystem -lboost_system

src/rannot/rannot.hpp src/rannot/rannot.cpp: src/rannot/rannot.y
	${BISON_BIN} -v -d -o src/rannot/rannot.cpp src/rannot/rannot.y

src/utils/annotmanagerutils.o: src/utils/annotmanagerutils.cpp src/utils/annotmanagerutils.hpp src/rannot/rannot.hpp
	${CC} ${COMPILEFLAGS}  -o $@ -c $<

%.o: %.cpp %.hpp src/hddl/hddl.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

%.o: %.cpp src/hddl/hddl.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

src/hddl/hddl-token.cpp: src/hddl/hddl.cpp src/hddl/hddl-token.l
	flex --yylineno -o src/hddl/hddl-token.cpp src/hddl/hddl-token.l

src/hddl/hddl.cpp: src/hddl/hddl.y
	${BISON_BIN} -v -d -o src/hddl/hddl.cpp src/hddl/hddl.y

src/hddl/hddl.hpp: src/hddl/hddl.cpp

%.o: %.cpp %.hpp src/rannot/rannot.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

%.o: %.cpp src/rannot/rannot.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

src/rannot/rannot-token.cpp: src/rannot/rannot.cpp src/rannot/rannot-token.l
	flex -o src/rannot/rannot-token.cpp src/rannot/rannot-token.l

%.o: %.cpp %.hpp src/queryparser/queryparser.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

%.o: %.cpp src/queryparser/queryparser.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

src/queryparser/queryparser-token.cpp: src/queryparser/queryparser.cpp src/queryparser/queryparser-token.l
	flex -o src/queryparser/queryparser-token.cpp src/queryparser/queryparser-token.l

src/queryparser/queryparser.cpp: src/queryparser/queryparser.y
	${BISON_BIN} -v -d -o src/queryparser/queryparser.cpp src/queryparser/queryparser.y
	
src/queryparser/queryparser.hpp: src/queryparser/queryparser.cpp

%.o: %.cpp %.hpp src/conditionparser/conditionparser.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

%.o: %.cpp src/conditionparser/conditionparser.hpp
	${CC} ${COMPILEFLAGS} -o $@ -c $<

src/conditionparser/conditionparser-token.cpp: src/conditionparser/conditionparser.cpp src/conditionparser/conditionparser-token.l
	flex -o src/conditionparser/conditionparser-token.cpp src/conditionparser/conditionparser-token.l

src/conditionparser/conditionparser.cpp: src/conditionparser/conditionparser.y
	${BISON_BIN} -v -d -o src/conditionparser/conditionparser.cpp src/conditionparser/conditionparser.y
	
src/conditionparser/conditionparser.hpp: src/conditionparser/conditionparser.cpp


clear:
	rm src/hddl/hddl-token.cpp
	rm src/hddl/hddl.cpp
	rm src/hddl/hddl.hpp
	rm src/hddl/*o

clear2:
	rm src/rannot/rannot-token.cpp
	rm src/rannot/rannot.cpp
	rm src/rannot/rannot.hpp
	rm src/rannot/rannot/*o

clear3:
	rm src/queryparser/queryparser-token.cpp
	rm src/queryparser/queryparser.cpp
	rm src/queryparser/queryparser.hpp
	rm src/queryparser/queryparser/*o

clear4:
	rm src/conditionparser/conditionparser-token.cpp
	rm src/conditionparser/conditionparser.cpp
	rm src/conditionparser/conditionparser.hpp
	rm src/conditionparser/conditionparser/*o
