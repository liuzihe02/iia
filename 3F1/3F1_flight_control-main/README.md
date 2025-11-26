# 3F1_flight_control

This is an updated version of the 3F1 Flight Control Lab. The original lab was based on MATLAB scripts authored by M. C. Smith in 1994. This version of the lab takes the form of a Jupyter notebook, and was written by C. Micou in 2022.

## Running the 3F1 lab on your own computer

Please note that the lab is only intended to run on department machines (on Linux), and that these steps are provided as 'best effort support' (with no guarantee of it actually working on a non-department computer).

These instructions assume that you already have Python 3.10 installed on your computer. Other versions of Python may not work, and at the time of writing there are known issues with Python 3.11 and upwards on Mac.

### MacOS/Linux

The `flight_control_lab` contains a 'blank-slate' version of the notebook. From within the `flight_control_lab` directory, the best way to get started is:

(1) Create a Python virtual environment:
```
python3 -m venv env
```

(2) Activate the virtual environment:
```
source env/bin/activate
```

(3) Install the requirements:
```
pip install -r requirements.txt
```

(4) Launch the notebook:
```
jupyter 3f1_lab.ipynb
```

Additional notes:
* If you have multiple versions of Python on your computer, you can explicitly run Python 3.10 by replacing `python3` with `python3.10` in the snippet above.
* Setting up the lab will fail unless you have the SDL2 library installed. Most computers will already have this installed, but if you are missing it you should install it via your package manager (`apt-get` on Linux, `brew` on OSX).

### Windows

The `flight_control_lab` contains a 'blank-slate' version of the notebook. From within the `flight_control_lab` directory, the best way to get started is:

(1) Create a Python virtual environment:
```
python -m venv env
```

(2) Activate the virtual environment:
```
env\Scripts\activate.bat
```

(3) Install the requirements:
```
pip install -r requirements.txt
```

(4) Launch the notebook:
```
jupyter 3f1_lab.ipynb
```
