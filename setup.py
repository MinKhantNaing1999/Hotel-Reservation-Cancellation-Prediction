from setuptools import setup,find_packages

with open("requirements.txt") as f:
    requirements = f.read().splitlines()

setup(
    name = "Hotel reservation project",
    version = "1",
    author = "Min Khant Naing",
    email = "minkhantnaing344@gmail.com",
    packages = find_packages(),
    install_requires = requirements,
)