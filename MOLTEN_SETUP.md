# Molten.nvim Setup Instructions

## Overview
Molten.nvim has been configured following the official repository guidelines to provide a Jupyter-like notebook experience directly in your editor.

**Repository**: https://github.com/benlubas/molten-nvim

## Requirements

### System Requirements
- **Neovim 9.4+** (current requirement)
- **Python 3.10+** (minimum version)

### Required Python Dependencies
```bash
# Core requirements (MUST have)
pip install pynvim jupyter-client

# Fix Python provider if needed
pip install --upgrade pynvim
```

### Optional Python Dependencies
```bash
# For enhanced functionality (recommended)
pip install cairosvg       # SVG transparency support
pip install pnglatex       # LaTeX formula display
pip install plotly kaleido # Plotly figure rendering
pip install pyperclip      # Clipboard integration
pip install nbformat       # Notebook format support
pip install pillow         # Image processing
pip install requests websocket-client  # Jupyter server API

# For .ipynb file support
pip install jupytext
```

### Terminal Requirements
- **Kitty** terminal (recommended) for image display
- **Wezterm** as alternative
- Or any terminal supporting Kitty graphics protocol

### Python Provider Setup
If you get Python provider errors, set the Python path:
```lua
-- Add to your Neovim config
vim.g.python3_host_prog = '/path/to/your/python3'
```

### Jupyter Kernels Setup
```bash
# Install ipykernel in your environment
pip install ipykernel

# Register kernel (optional, for multiple environments)
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"

# List available kernels
jupyter kernelspec list
```

## Usage

### Key Mappings
All Molten commands are prefixed with `<leader>m`:

**Core Commands:**
- `<leader>mi` - Initialize Molten kernel (select from available kernels)
- `<leader>me` - Evaluate operator (followed by motion, e.g., `<leader>meip` for paragraph)
- `<leader>ml` - Evaluate current line
- `<leader>mc` - Re-evaluate current cell
- `<leader>mv` - Evaluate visual selection (in visual mode)

**Output Management:**
- `<leader>md` - Delete cell output
- `<leader>mh` - Hide output
- `<leader>ms` - Show/enter output window
- `<leader>mp` - Show image popup (for plots)

**Kernel Management:**
- `<leader>mI` - Interrupt kernel execution
- `<leader>mR` - Restart kernel

**Notebook Integration:**
- `<leader>mE` - Export outputs to .ipynb file
- `<leader>mP` - Import outputs from .ipynb file
- `<leader>mS` - Save session
- `<leader>mL` - Load session

### Navigation
- `]m` - Next molten cell
- `[m` - Previous molten cell
- `]c` - Next code cell (Python files with # %% markers)
- `[c` - Previous code cell

### Cell Markers
In Python files, use these markers to define cells:
```python
# %%
# This is a code cell
import numpy as np
import matplotlib.pyplot as plt

# %%
# Another cell
data = np.random.randn(100)
plt.hist(data)
plt.show()
```

### Working with Notebooks (.ipynb files)
The Jupytext plugin automatically converts .ipynb files to markdown when you open them.
Molten can then execute the code cells within these markdown files.

1. Open a .ipynb file - it will be converted to markdown
2. Use `<leader>mi` to initialize a kernel
3. Use `<leader>mP` to import existing outputs from the notebook
4. Execute cells as normal
5. Use `<leader>mE` to export back to .ipynb format

### Tips

1. **Virtual Environment Support**: Molten respects your active Python environment
2. **Multiple Kernels**: You can have different kernels for different languages
3. **Inline Output**: Outputs appear as virtual text below executed code
4. **Image Support**: Plots and images are displayed inline (requires Kitty terminal)
5. **Persistent Sessions**: Save and load your work with `<leader>mS` and `<leader>mL`

## Troubleshooting

1. **"No kernels found"**: Run `jupyter kernelspec list` to verify kernels are installed
2. **Images not displaying**: Ensure you're using Kitty terminal or have image.nvim properly configured
3. **Kernel won't start**: Check that `jupyter-client` is installed in your Python environment
4. **UpdateRemotePlugins error**: Run `:UpdateRemotePlugins` in Neovim and restart

## Example Workflow

```python
# %% [markdown]
# # Data Analysis Example

# %%
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# %%
# Load data
df = pd.read_csv('data.csv')
df.head()

# %%
# Visualize
plt.figure(figsize=(10, 6))
sns.heatmap(df.corr(), annot=True)
plt.show()
```

1. Save this as `analysis.py`
2. Open in Neovim
3. Run `<leader>mi` and select Python kernel
4. Navigate to cells and run with `<leader>mc`
5. View inline outputs and plots