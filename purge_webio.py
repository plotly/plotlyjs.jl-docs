import bs4
import sys
import os


def strip_webio(html_str):
    soup = bs4.BeautifulSoup(html_str, features="lxml")
    for el in soup.find_all("div", class_="output_html"):
        if "webio" in el.getText().lower():
            el.decompose()

    return str(soup)


def main():
    fn = sys.argv[1]

    if not os.path.isfile(fn):
        raise ValueError("Unknown file {fn}".format(fn))
    with open(fn, "r") as f:
        contents = f.read()

    start = contents.find(r"{% raw %}") + len(r"{% raw %}")
    end = contents.find(r"{% endraw %}")
    html_str = contents[start:end]
    cleaned = strip_webio(html_str)

    out_fn = sys.argv[2]
    with open(out_fn, "w") as f:
        f.write(contents[:start])
        f.write("\n")
        f.write(cleaned)
        f.write("\n")
        f.write(contents[end:])


if __name__ == "__main__":
    main()
