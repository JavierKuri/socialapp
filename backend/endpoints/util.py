import json
from neo4j import GraphDatabase

def get_json_body(handler):
    length = int(handler.headers.get("Content-Length", 0))
    body = handler.rfile.read(length)
    return json.loads(body)

URI = "bolt://localhost:7687"
USER = "neo4j"
PASSWORD = "password"
_driver = None

def connect_db():
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(URI, auth=(USER, PASSWORD))
    return _driver

def close_db():
    global _driver
    if _driver is not None:
        _driver.close()
        _driver = None

def get_db_session():
    driver = connect_db()
    return driver.session()