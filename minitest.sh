docker run -v $(pwd):/project $1 bash -c "touch test.txt"
rm test.txt