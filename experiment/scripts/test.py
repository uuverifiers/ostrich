from time import sleep
from tqdm import tqdm, trange
from concurrent.futures import ThreadPoolExecutor

L = list(range(2))

def progresser(n):
    interval = 0.001 / (n + 2)
    total = 5000
    text = "#{}, est. {:<04.2}s".format(n, interval * total)
    for _ in tqdm(range(total)):
        sleep(interval)
    if n == 6:
        tqdm.write("n == 6 completed.")
        tqdm.write("`tqdm.write()` is thread-safe in py3!")

if __name__ == '__main__':
    with ThreadPoolExecutor(max_workers=4) as p:
        p.map(progresser, L)