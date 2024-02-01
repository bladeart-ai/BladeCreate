# BladeCreate

Free and open-source cross-platform AI canvas for everyone

- Unleash your creativity for artistic expression, graphic design, and content creation with AI-facilitated workflows.
- Free on your own hardware, whether you have a desktop computer or a workstation. (Mobile support to be added)
- Empowered by community AI models.

[Features](#features) - [Installation](#installation)

## Installation

1. Create and activate your conda environment

```bash
conda create -n bladecreate python=3.10
conda activate bladecreate
```

2. Install Python dependencies

```bash
sh scripts/install_dev.sh
```

3. Install WebUI

```bash
cd webui && pnpm install
```

4. Start everything

```bash
sh scripts/run_prod_all.sh
```

## Roadmap

### V0 Basics

- [x] Canvas basics: non-destructive layers, layer transformation, generation progression
- [x] Cluster basics: worker queue
- [x] SDXL: text-to-image (CUDA and Apple CoreML)
- [x] Internationalization: english and 中文
- [ ] Mac dmg installation

### V1 Cross-platform and More Creation Modes

- [ ] Canvas basics: inpainting, image-to-image, fast preview
- [ ] Cross-platform support: Mobile (iPad, Andriod) and Desktop (Windows), project importing and exporting
- [ ] SDXL: image-to-image (CUDA and Apple CoreML)
- [ ] SDXL Turbo

### V2 Community Models

- [ ] Model management: importing from files and URLs, model validation
- [ ] SD 2.0 + Lora
- [ ] SD 1.5 + Lora
- [ ] Cluster basics: muti-worker for multi-GPUs
