'''
DOCSTRING: Gunicorn startup script for the application.
'''
gunicorn --bind 0.0.0.0:8000 webledger:app