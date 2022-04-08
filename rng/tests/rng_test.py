from rng.rng.py import rng
import socket
import pytest

@pytest.fixture 
def index_test():
    return rng.index()

def test_index_content(index_test):
    hostname = socket.gethostname()
    assert  "RNG running on {}\n".format(hostname) in index_test 

def test_rng_status():
    statuscode = rng.rng(32).status_code
    assert statuscode == 200