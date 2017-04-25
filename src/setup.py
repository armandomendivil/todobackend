from setuptools import setup, find_packages

setup (
    name                    = "todobackend",
    version                 = "0.1.0",
    description             = "Todobacken Djange REST service",
    packages                = find_packages(),
    include_package_data    = True,
    scripts                 = ["manage.py"],
    install_requires        = ["appdirs>=1.4.3",
                               "Django>=1.9,<2.0",
                               "django-cors-headers>=1.1.0",
                               "djangorestframework>=3.3.0",
                               "MySQL-python>=1.2.5",
                               "packaging>=16.8",
                               "pyparsing>=2.2.0",
                               "six>=1.10.0",
                               "uwsgi>=2.0"],
   extras_require           = {
                                 "test": [
                                    "appdirs>=1.4.3",
                                    "colorama>=0.3.7",
                                    "coverage>=4.3.4",
                                    "django-nose>=1.4.4",
                                    "nose>=1.3.7",
                                    "packaging>=16.8",
                                    "pinocchio>=0.4.2",
                                    "pyparsing>=2.2.0",
                                    "six>=1.10.0"
                                  ]
                              }
)
