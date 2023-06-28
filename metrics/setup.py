from setuptools import setup, find_packages

setup(
    name='lst-metrics',
    description='LST-Bench Metrics and analysis',
    url='https://github.com/microsoft/lst-bench',
    license='Apache License, 2.0',
    version='0.1',
    packages=find_packages(),
    install_requires=[
        'pandas>=1.5.3',
    ],
)

