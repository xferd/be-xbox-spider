package xbox

import (
    "net/http"
    "io"
    "bufio"
    "os"
    // "hash/crc32"
    "fmt"
    // "log"
)

type ProductIDChan chan ProductID

var (
    client http.Client
    idChan ProductIDChan = make(ProductIDChan)
)

const (

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

func (ch ProductIDChan)walkAll() {
    fp, err := os.Open(ProductIDListFile)
    if nil != err {
        panic(err)
    }
    defer fp.Close()

    rd := bufio.NewReader(fp)
    go func() {
        for {
            if line, err := rd.ReadString('\n'); nil == err {
                if nil != err || io.EOF == err {
                    break
                }
                ch <- ProductID(line)
            }
        }
    }()
}

func Crawl() {
    idChan.walkAll()
    for id := range idChan {
        fmt.Println(id)
    }
}

func (ch ProductIDChan)Fetch(productIDs, market, languages string) {
    uri := fmt.Sprintf(URLFormat, productIDs, market, languages)
    resp, err := client.Get(uri)
    if nil != err {
        panic(err)
    }
    defer resp.Body.Close()

    // body, err := ioutil.ReadAll(resp.Body)
    // if err != nil {
    //     panic(err)
    // }
    // log.Println("fetched url")
    // ch <- string(body)
}
