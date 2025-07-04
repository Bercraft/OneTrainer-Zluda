# Insert ourselves as the highest-priority library path, so our modules are
# always found without any risk of being shadowed by another import path.
# 3 .parent calls to navigate from /scripts/util/import_util.py to the main directory

import os
import sys
from pathlib import Path

onetrainer_lib_path = Path(__file__).absolute().parent.parent
sys.path.insert(0, str(onetrainer_lib_path))

from modules.ui.TrainUI import TrainUI

def main():
    ui = TrainUI()
    ui.mainloop()


if __name__ == '__main__':
    main()
