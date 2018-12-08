package xbox

import (
    "net/http"
    "io"
    "bufio"
    "os"
    "fmt"
    "log"
    "io/ioutil"
)

type ProductIDChan chan ProductID
type Bag ProductIDList

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
    go func() {
        fp, err := os.Open(ProductIDListFile)
        if nil != err {
            panic(err)
        }
        log.Printf("product id list file opened")
        defer fp.Close()

        rd := bufio.NewReader(fp)
        for {
            if line, _, err := rd.ReadLine(); nil == err || io.EOF != err {
                log.Printf("read line: %s", line)
                ch <- ProductID(line)
            } else {
                log.Printf("%+v", err)
                break
            }
        }
        close(ch)
    }()
}

func Crawl() {
    log.Printf("crawling")
    idChan.walkAll()
    var max, cnt = 10, 0
    bag := Bag{}
    for id := range idChan {
        cnt++
        bag.Add(id)
        if cnt >= max {
            bag.Flush()
            cnt = 0
        }
        fmt.Println(id)
    }
    bag.Flush()
}

func (b *Bag)Add(id ProductID) {
    *b = append(*b, id)
}

func (b *Bag)Flush() {
    log.Println(b)
    theURL := ProductIDList(*b).ProductURL("HK", "zh-cn")
    log.Println(theURL)
    resp, err := GetURL(theURL)
    if nil != err {
        panic(err)
    }
    *b = Bag{}
    WriteProduct(theURL, resp)
}

func WriteProduct(url, data string) {
    md5 := MD5([]byte(url))
    log.Println(md5)
    filepath := fmt.Sprintf("%s%s", ProductDir, md5)
    ioutil.WriteFile(filepath, []byte(data), os.ModePerm)
}
