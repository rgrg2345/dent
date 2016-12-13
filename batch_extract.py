from sys import argv

from extract_data import extract


def padding(n):
    fn = str(n)
    if len(fn) < 5:
        fn = "0" * (5 - len(fn)) + fn
    return fn


def batch(n1, n2):
    now = n1
    prefix = "LOG"
    while now <= n2:
        fn = prefix + padding(now) + ".TXT"
        extract(fn)
        now += 1
if __name__ == '__main__':
    if len(argv) < 3:
        raise Exception("need range n1 n2")
    else:
        batch(int(argv[1]), int(argv[2]))
