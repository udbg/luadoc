# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'UDbgLuaDoc'
copyright = '2021, metaworm'
author = 'metaworm'

# The full version, including alpha/beta/rc tags
release = '0.2'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinxcontrib.luadomain',
    'sphinx_lua',
    'sphinx.ext.autosummary',
]

lua_source_path = ["."]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'pyramid'
html_theme = 'classic'
html_theme = 'nature'
html_theme = 'alabaster'
html_theme = 'sphinx_material'   # pip install sphinx-material
html_theme = "sphinx_book_theme" # pip install sphinx-book-theme
html_theme = 'sphinx-typlog-theme' # pip install git+https://github.com/typlog/sphinx-typlog-theme
html_theme = 'scipy' # git clone --depth=1 https://github.com/scipy/scipy-sphinx-theme doc/_theme/scipy-sphinx-theme
html_theme = 'sphinxdoc'
html_theme = 'haiku'

# html_theme = 'bizstyle'
# html_theme_options = {
#     'rightsidebar': True,
# }

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

highlight_language = 'lua'

# Language to be used for generating the HTML full-text search index.
# Sphinx supports the following languages:
#   'da', 'de', 'en', 'es', 'fi', 'fr', 'hu', 'it', 'ja'
#   'nl', 'no', 'pt', 'ro', 'ru', 'sv', 'tr', 'zh'
html_search_language = 'zh'  # pip install jieba

language = 'zh_CN'