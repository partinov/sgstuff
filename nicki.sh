
test="$1"

ou="$(curl -skLI --max-time 5 -H 'Cache-Control: no-cache' "$1" | grep -i 'location' | cut -d ' ' -f 2 | tr -d '\r')"

while IFS= read -r line
do
   test="${test} >>> ${line}"
done < <(printf '%s\n' "$ou")

echo "Result: "
echo "$test"