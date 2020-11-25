#!/bin/bash

UA="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36"
list=$(curl -H "$UA" -L 'https://www.avito.ru/sankt-peterburg/telefony/iphone-ASgBAgICAUSeAt4J?bt=1&cd=1&i=1&q=iphone+7&s=104' |
grep -A1 'data-marker="item-title"' |
grep href |
sed 's|href="|http://avito.ru|g' | sed 's|"||g')

echo "$list" | while read -r url
do
    price=$(curl -s -H "$UA" -L $url |
    grep 'itemprop="price"' |
    ggrep -oP '(?<=content=").*?(?=")' |
    head -1)

    echo $price $url
    if (($price <= 9000)) && (($price >= 6000)); then
        echo $price, $url >> output.csv
        osascript -e "display notification \"Нашел за $price\""
    fi

    sleep 12
done