#colors
ccred:="\033[46;31m"
ccyellow:="\033[46;34m"
ccgreen:="\033[40;32m"
ccend:="\033[0m"

SRC_CU := $(shell find -name '*.cu')
SRC_CPP := $(shell find -name '*.cpp')

#only used for cls function
OBJ_CURR := $(shell find -name '*.o')

OBJ_CU := $(SRC_CU:%.cu=%.o)
OBJ_CPP := $(SRC_CPP:%.cpp=%.o)
OBJ_ALL := $(OBJ_CU) $(OBJ_CPP)

ifeq "$(OBJ_CU)" ""
OBJ_CUDA_L :=
else
OBJ_CUDA_L := cudatemp.o
endif

NVCC := nvcc -O3
GCC := g++ -O3 -fopenmp
NVARCH := -arch=sm_30
NVCCFLAG := -std=c++11
OUT := EXECUTABLE
LIBPATH = -L"/usr/local/cuda-7.0/lib64"

LIBLST = -lcuda -lcudart -lSDL2 -lGL

$(OUT): $(OBJ_CPP) NVCCLINK
	@echo $(ccgreen)link all objects:$(ccend)
	@echo $(ccgreen)"$(OBJ_ALL)"$(ccend)| sed -e 's/ /\x1b[0m\n\x1b[40;32m/g'
	@$(GCC) -o $(OUT) $(OBJ_CUDA_L) $(OBJ_ALL) $(LIBPATH) $(LIBLST)
	@for ob in $(OBJ_ALL) ; do \
	echo $(ccred) delete: $$ob $(ccend);rm -rf $$ob ; \
	done
ifeq "$(OBJ_CUDA_L)" ""
	@echo $(ccred) delete: $(OBJ_CUDA_L) $(ccend)
endif
	@rm -rf $(OBJ_CUDA_L)
	@echo $(ccgreen)Object $(OUT) successfully compiled$(ccend)
	@echo "Makefile by Neko <nekoyuke@gmail.com>"

NVCCLINK: $(OBJ_CU)
ifeq "$(OBJ_CU)" ""
	@echo $(ccgreen)No CUDA files to link$(ccend)
else
	@echo $(ccgreen)CUDA-link objects:$(ccend)
	@echo $(ccgreen)"$(OBJ_CU)"$(ccend)| sed -e 's/ /\x1b[0m\n\x1b[40;32m/g'
	@echo $(ccend)
	@$(NVCC) $(NVARCH) $(NVCCLINKFLG) -dlink -o $(OBJ_CUDA_L) $(OBJ_CU) $(LIBPATH) $(LIBLST)
endif

%.o: %.cu
	@echo $(ccyellow)CUDA $(NVCC) compile:$<$(ccend)
	@$(NVCC) $(NVARCH) -c -o $@ $<

%.o: %.cpp
	@echo $(ccyellow)std $(GCC) compile:$<$(ccend)
	@$(GCC) -w -std=c++11 -c -o $@ $<

.PHONY: clean
clean:
	@echo $(ccred) delete: $(OUT) $(ccend)
	@rm -rf $(OUT)
	@for ob in $(OBJ_CURR) ; do \
	echo $(ccred) delete: $$ob $(ccend);rm -rf $$ob ; \
	done
