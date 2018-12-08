package xbox

import (
    "net/http"
    // "net/url"
    "io/ioutil"
    // "io"
    // "os"
    // "hash/crc32"
    "fmt"
    "log"
)

type SpiderChan chan string

var (
    client http.Client
)

const (
    URLFormat = "https://displaycatalog.mp.microsoft.com/v7.0/products?bigIds=%s&market=%s&languages=%s&MS-CV=DAU1mcuxoWMMp+F.1"
)

func init() {
    // urli := url.URL{}
    // urlproxy, _ := urli.Parse("http://10.99.93.35:8080")
    client = http.Client{
        Transport: &http.Transport{
            // Proxy: http.ProxyURL(urlproxy),
        },
    }
}

func (ch SpiderChan)Fetch(productIDs, market, languages string) {
    uri := fmt.Sprintf(URLFormat, productIDs, market, languages)
    resp, err := client.Get(uri)
    if nil != err {
        panic(err)
    }
    defer resp.Body.Close()

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        panic(err)
    }
    log.Println("fetched url")
    ch <- string(body)
}
