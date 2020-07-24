
import argparse

parser = argparse.ArgumentParser(description='Random/Sorted Music Player')
parser.add_argument('--sorted', action='store_true',
                    help='sorted the musics')

args = parser.parse_args()
print(args.sorted)
