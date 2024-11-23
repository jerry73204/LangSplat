.PHONY: default prepare build clean

SHELL = bash
DATASET_DIR = dataset

default:
	@echo 'Usage:'
	@echo 'make prepare  # Prepare the Conda environment'
	@echo 'make build    # Build the project'
	@echo 'make clean    # Clean the build'

prepare:
	export CUDA_HOME=/usr/local/cuda-11.8 && \
	conda env create --file environment.yml

preprocess:
	python preprocess.py --dataset_path $(DATASET_DIR)

train:
	# train the autoencoder
	cd autoencoder && \
	python train.py \
		--dataset_name $(DATASET_DIR) \
		--encoder_dims 256 128 64 32 3 \
		--decoder_dims 16 32 64 128 256 256 512 \
		--lr 0.0007 \
		--output ae_ckpt

	# get the 3-dims language feature of the scene
	python test.py --dataset_name $(DATASET_DIR) --output


clean:
	conda env remove -y -n langsplat
