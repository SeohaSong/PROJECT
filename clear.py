
from shs.gardener import clear_current_dir


if __name__ == '__main__':

    clear_current_dir([
        '.DS_Store',
        '__pycache__',
        '.ipynb_checkpoints',
        '.vscode'
    ])
